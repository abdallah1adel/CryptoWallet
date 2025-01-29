//
//  HomeStatsticView.swift
//  CryptoWallet
//
//  Created by pcpos on 01/01/2025.
//

import SwiftUI

struct HomeStatsticView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    var body: some View {
        HStack {
            ForEach((vm.Statistics)) { stat in
                StatisticView (stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

    
    
    
struct HomeStatsticView_Preivews: PreviewProvider {
    
    static var previews: some View {
        
        HomeStatsticView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
        
    }
}
