//
//  coinDataService.swift
//  CryptoWallet
//
//  Created by pcpos on 21/12/2024.
//

import Foundation
import Combine

class coinDataService {
    
    @Published var allCoins: [CoinModel] = []
     var coinSubscription :AnyCancellable?  // Store subscriptions
    
    
    init() {
        getCoins()
    }// Automatically call getCoins when the service is initialized
    
     func getCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        coinSubscription = NetworkingManger.download(url: url)
//        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .default))// Use global queue for network call
//        //            .trMap{ (output) -> Data in
//        //                guard let response = output.response as? HTTPURLResponse,
//        //                      response.statusCode >= 200 && response.statusCode <= 300 else { throw URLError(.badServerResponse) }
//        //                return output.data
//        //            }
//            .tryMap { output -> Data in  // Corrected to tryMap for error handling
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode <= 300 else {
//                    throw URLError(.badServerResponse)  // Handle bad server response
//                }
//                return output.data
//            }
//            .receive(on: DispatchQueue.main)// Ensure UI updates on the main thread
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManger.handleCompletion,
                  receiveValue: {  [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
                self?.coinSubscription?.cancel()
            })
//            .sink { (completion) in // Completion handler
//                switch completion {
//                case.finished:break
//                case.failure(let error): print("Error: \(error.localizedDescription)")
//                }
//            } receiveValue : { [weak self] (returnedCoin) in
//                self?.allCoins = returnedCoin
//                self?.coinSubscription?.cancel()
//
//            }
            //.store(in: &cancellables)// Store the subscription to prevent memory leaks
    }
}
