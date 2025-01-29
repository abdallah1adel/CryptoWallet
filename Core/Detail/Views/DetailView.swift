//
//  DetailView.swift
//  CryptoWallet
//
//  Created by pcpos on 05/01/2025.
//

import SwiftUI


struct DetailLoadingView : View {
    
    @Binding var coin : CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }}
    }
}

struct DetailView: View {
    @StateObject private var vm : DetailViewModel
    
    @State var showFullDescription : Bool = false
    private let columns : [GridItem] =
    [GridItem(.flexible()),
     GridItem(.flexible())
    ]
    
    private var spacing: CGFloat = 30
    
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            
            VStack {
                ChartView(coin: vm.coin)
            }.padding(.vertical)
            
            VStack (spacing: 20) {
                overviewTitle
                Divider()
                descreptionSection
                overviewGrid
                additinalTitle
                Divider()
                additionalGrid
                websiteSection
                
            }
            .padding()
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigaitonBarTrailingIcon
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}


extension DetailView {
    
    private var navigaitonBarTrailingIcon : some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.seconderyText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
        //.padding()
    }
    private var overviewTitle : some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additinalTitle : some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid : some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
            
                ForEach(vm.overviewStatistics){ statistic in
                    StatisticView(stat: statistic)
                }
        }//lazyVGrid
    }
    
    private var additionalGrid : some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
            
                ForEach(vm.additinalStatistics){ statistic in
                    StatisticView(stat: statistic)
                }
        }//lazyVGrid

    }
    
    private var  descreptionSection : some View {
        ZStack {
            if let coinDescription = vm.coinDescription , !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.seconderyText)
                    Button ( action:{
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()}
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read More...")
                            .font(.caption)
                            .bold()
                            .padding(.vertical,4)
                    })
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
    }
    
    
    private var websiteSection : some View {
        VStack(alignment: .leading,spacing: 10) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link("website", destination: url)
            }
            
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link("reddit", destination: url)
            }
               
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
