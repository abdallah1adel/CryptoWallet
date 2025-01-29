//
//  Color.swift
//  CryptoWallet
//
//  Created by pcpos on 16/12/2024.
//

import Foundation
import SwiftUI


extension Color {
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}


struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let seconderyText = Color("SecondaryTextColor")
}
struct ColorTheme2 {
    
    let accent = Color(.white)
    let background = Color(.black)
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let seconderyText = Color("SecondaryTextColor")
}


struct LaunchTheme {
    
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
