//
//  DetailViewModel.swift
//  CryptoWallet
//
//  Created by pcpos on 06/01/2025.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics : [StatisticModel] = []
    @Published var additinalStatistics : [StatisticModel] = []
    @Published var coinDescription : String? = nil
    @Published var websiteURL : String? = nil
    @Published var redditURL : String? = nil
    
    @Published var coin : CoinModel
    private let coinDetailSerivce: CoinDetailDataService
    private var cancellables: Set<AnyCancellable> = []
    
    init(coin : CoinModel) {
        self.coin = coin
        self.coinDetailSerivce = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        coinDetailSerivce.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additinalStatistics = returnedArrays.additinal
            }
            .store(in: &cancellables)
        
        coinDetailSerivce.$coinDetails
            .sink { [weak self]  (returenedCoinDetails) in
                self?.coinDescription = returenedCoinDetails?.readableDescription
                self?.websiteURL = returenedCoinDetails?.links?.homepage?.first
                self?.redditURL = returenedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
        
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additinal: [StatisticModel]) {
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additinalArray = createAdditinalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        return (overviewArray, additinalArray)
    }
    
     private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        //overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStatistics = StatisticModel(title: "Current Price", value: price, persentageChange: pricePercentChange)
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStatistics = StatisticModel(title: "Market Cap", value: marketCap, persentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStatistics = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStatistics = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray : [StatisticModel] = [
            priceStatistics,marketCapStatistics,rankStatistics,volumeStatistics
        ]
        return overviewArray
    }
    
    private func createAdditinalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        //additinal
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        //                let highChange = coinModel.high24HChangePercentage
        let highStatistics = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        //                let lowChange = coinModel.low24HChangePercentage
        let lowStatistics = StatisticModel(title: "24h Low", value: low)
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStatistics = StatisticModel(title: "24h Price Change", value: priceChange, persentageChange: pricePercentChange)
        
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStatistics = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, persentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime  )"
        let blockTimeStatistics = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStatistics = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additinalArray : [StatisticModel] = [
            highStatistics,lowStatistics,priceChangeStatistics,marketCapChangeStatistics,blockTimeStatistics,hashingStatistics
        ]
        return additinalArray
    }
}
    
    
    


