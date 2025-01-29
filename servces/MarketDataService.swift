//
//  MarketDataService.swift
//  CryptoWallet
//
//  Created by pcpos on 03/01/2025.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
     var marektSubscription :AnyCancellable?  // Store subscriptions
    
    init() {
        getMarketData()
    }
    
     func getMarketData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        marektSubscription = NetworkingManger.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManger.handleCompletion,
                  receiveValue: {  [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marektSubscription?.cancel()
            })
    }
}
