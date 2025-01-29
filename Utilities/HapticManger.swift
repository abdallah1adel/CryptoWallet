//
//  HapticManger.swift
//  CryptoWallet
//
//  Created by pcpos on 05/01/2025.
//

import Foundation
import SwiftUI


class HapticManger {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notficiation(type:UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
        
    }
}
