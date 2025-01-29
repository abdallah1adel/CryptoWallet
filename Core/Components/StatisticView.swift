//
//  StatisticView.swift
//  CryptoWallet
//
//  Created by pcpos on 01/01/2025.
//

import SwiftUI

struct StatisticView: View {
    
    let stat : StatisticModel
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.seconderyText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                //to rotate the arrow based on change in persentage
                    .rotationEffect(
                        Angle(degrees:(stat.persentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(stat.persentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.persentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.persentageChange == nil ? 0.0 : 1.0)
            
        }
    }
}




struct StatisticView_Preivews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            StatisticView(stat: dev.stat1)
            StatisticView(stat: dev.stat2)
            StatisticView(stat: dev.stat3)
        }
        .previewLayout(.sizeThatFits)
        
    }
}
