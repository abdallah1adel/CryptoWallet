//
//  HomeViewModel.swift
//  CryptoWallet
//
//  Created by pcpos on 21/12/2024.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var Statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var PortfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: sortOption = .holdings
    
    private let CoinDataService = coinDataService()
    private let marketDataService = MarketDataService()
    private let protocolDataService = PortfolioDataService()
    
    private var cancellables: Set<AnyCancellable> = []
    
    enum sortOption {
        
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
        
    }
    
    init() {
        addSubscribers()
    }
    // Subscribers function
    func addSubscribers() {
        ///update allCoins
        $searchText
            .combineLatest(CoinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        ///update portfolioCoin
        $allCoins
            .combineLatest(protocolDataService.$savedEntities)
            .map (mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.PortfolioCoins = self.sortPortfolioCoins(coins: returnedCoins, sortOption: self.sortOption)
            }
            .store(in: &cancellables)
        
        ///updates marketData
        marketDataService.$marketData
            .combineLatest($PortfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.Statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
       
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        print("Updating portfolio with coin: \(coin.name) and amount: \(amount)")
        protocolDataService.updatePortfolio(coin: coin, amount: amount)
    }

    
//    func updatePortfolio(coin: CoinModel, amount: Double) {
//        protocolDataService.updatePortfolio(coin: coin, amount: amount)
//    }

    func  reloadData(){
        isLoading = true
        CoinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManger.notficiation(type: .success)
        
    }
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: sortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        updatedCoins = sortCoins(coins: updatedCoins, sort: sort) // Update the sorted list
        return updatedCoins
    }

//    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: sortOption)->[CoinModel] {
//        
//        var updatedCoins = filterCoins(text: text, coins: coins)
//        sortCoins(coins: updatedCoins, sort: sort)
//        return updatedCoins
//        
//    }
    
    
    private func filterCoins(text: String, coins: [CoinModel])->[CoinModel] {
        
        guard !text.isEmpty else { return coins }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin)->Bool in
            return
            coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
        
    }
    
    private func sortCoins(coins:  [CoinModel], sort: sortOption) -> [CoinModel] {
        switch sort {
        case .rank,.holdings:
            return coins.sorted(by: { $0.rank < $1.rank } )
        case.rankReversed,.holdingsReversed:
            return coins.sorted(by: { $0.rank > $1.rank } )
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoins (coins: [CoinModel],sortOption: sortOption) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default :
            return coins
        }
    }
    
    
//    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel],portfolioEntities:[PortfolioEntity] ) -> [CoinModel] {
//        
//        allCoins.compactMap { (coin)-> CoinModel? in
//            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id })
//            else {return nil }
//            return coin.updateHoldings(amount: entity.amount)
//        }
//        
//    }
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        return allCoins.compactMap { (coin) -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

    
    
    private func mapGlobalMarketData( marketDataModel : MarketDataModel? , portfolioCoins : [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap,persentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfoioValue =
            portfolioCoins
            .map( { $0.currentHoldingsValue })
            .reduce(0, +)

        
        let previousPortfolioValue =
            portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentageChange)
                return previousValue
            }
            .reduce(0, +)

//        let previousPortfolioValue =
//            portfolioCoins
//            .map{ (coin) -> Double in
//            let currentValue = coin.currentHoldingsValue
//                let persetageChange = coin.priceChangePercentage24H! / 100
//                let previousValue = currentValue / (1 + persetageChange)
//                return portfoioValue
//   
//            }
//            .reduce(0, +)
        
        
        let persetageChange = (( portfoioValue - previousPortfolioValue) / previousPortfolioValue) * 100
        
        let portfolioValue = StatisticModel(title: "Portfolio Value",
                                            value: portfoioValue.asCurrencyWith2Decimals(),
                                            persentageChange: 0.0)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolioValue])
        return stats
    }
        
    
}
