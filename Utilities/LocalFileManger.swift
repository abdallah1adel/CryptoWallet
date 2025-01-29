//
//  LocalFileManger.swift
//  CryptoWallet
//
//  Created by pcpos on 25/12/2024.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init(){}
    
    func saveImage(image:UIImage,imageName:String, folderName:String) {
        
        createFolderIfNeeded(folderName: folderName)// create folder
        
        
        //getr path for image
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        //save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("error saving image. image name \(imageName). \(error)")
        }
        
    }
    
    func getImage(imageName:String, folderName:String) -> UIImage? {
        
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    
    private func createFolderIfNeeded(folderName:String){
        
        guard let url = getURLForFolder(folderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("error crearing directory. Folder name \(folderName). \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName:String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName:String, folderName:String) -> URL? {
        
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
