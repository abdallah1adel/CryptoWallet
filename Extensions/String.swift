//
//  String.swift
//  CryptoWallet
//
//  Created by pcpos on 06/01/2025.
//

import Foundation
extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
