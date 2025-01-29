//
//  CoinDetailDataService.swift
//  CryptoWallet
//
//  Created by pcpos on 06/01/2025.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails :CoinDetailModel? = nil
     var CoinDetailsSubscription :AnyCancellable?  // Store subscriptions
    let coin :CoinModel
    
    init(coin:CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
     func getCoinDetails() {
        
         guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
         CoinDetailsSubscription = NetworkingManger.download(url: url)
             .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
             .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManger.handleCompletion,
                  receiveValue: {  [weak self] (returnedCoinDetails) in
                self?.coinDetails = returnedCoinDetails
                self?.CoinDetailsSubscription?.cancel()
            })
    }
}
