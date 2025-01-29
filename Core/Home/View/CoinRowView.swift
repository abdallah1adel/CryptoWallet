//
//  CoinRowView.swift
//  CryptoWallet
//
//  Created by pcpos on 20/12/2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldeningsColumn: Bool
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldeningsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
    }
}

struct coinRowView_Previews: PreviewProvider{
    static var previews: some View{
        Group{
            CoinRowView(coin: dev.coin, showHoldeningsColumn: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, showHoldeningsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            //coin rank and symbol
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.seconderyText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        //coin price and states my wallet
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                Text((coin.currentHoldings ?? 0).asPercentString())
            }
    }
    
    private var rightColumn: some View {
        //coin price and states
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0 ) >= 0 ? Color.theme.green :
                        Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.3,alignment: .trailing)
        
    }
    
}
