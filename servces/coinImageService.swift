//
//  coinImageService.swift
//  CryptoWallet
//
//  Created by pcpos on 23/12/2024.
//

import Foundation
import SwiftUI
import Combine

class coinImageService: ObservableObject {
    
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    
    private var imageSubscription : AnyCancellable?
    private let coin : CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "Coin_Images"
    private let imageName : String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let saveIamge = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = saveIamge
            print("retrived image form file manger")
        } else {
            downloadCoinImage()
            print("downlaoding image now")
        }
    }
    
    
    private func downloadCoinImage() {
        
        print("downloading image now")
        guard let url = URL(string: coin.image) else { return }
        imageSubscription = NetworkingManger.download(url: url)
            .tryMap({ (Data) ->UIImage? in
                return UIImage(data: Data)
            })
            .receive(on: DispatchQueue.main)            .sink(receiveCompletion: NetworkingManger.handleCompletion,
                  receiveValue: {  [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
    
}
