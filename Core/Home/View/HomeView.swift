//
//  HomeView.swift
//  CryptoWallet
//
//  Created by pcpos on 20/12/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm : HomeViewModel

    @State private var ShowPortfolio: Bool = false//animate to the right
    @State private var ShowPortfolioView: Bool = false// new sheet
    @State private var ShowSettingsView: Bool = false// new sheet
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    
    var body: some View {
        ZStack {
            //Background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $ShowPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            //Content
            VStack {
                homeHeader
                
                HomeStatsticView(showPortfolio: $ShowPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                headBar
                
                if !ShowPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if ShowPortfolio {
                    ZStack(alignment: .top) {
                        if vm.PortfolioCoins.isEmpty && vm.searchText.isEmpty {
                            portfolioEmptyView
                        }else { portfolioCoinsList}
                    }
                    .transition(.move(edge: .trailing))
                }
                
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $ShowSettingsView) {
                SettingsView()
            }
            
            //Vsatck Content
            
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin), isActive: $showDetailView, label: {
                EmptyView()
            })
        )
        
        //Zstack
    }
    
}//HomeView Struct

//#Preview {
//    NavigationView{
//        HomeView()
//            .navigationBarHidden(true)
//    }
    
    struct HomeView_Previews: PreviewProvider{
        static var previews: some View{
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
        }
            .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: ShowPortfolio ? "plus":"info")
                .animation(.none)
                .onTapGesture {
                    if ShowPortfolio {
                        ShowPortfolioView.toggle()
                    } else {ShowSettingsView.toggle()}
                }
                .background(
                    CirclyButtonAnimationView(animation: $ShowPortfolio)
                )
            Spacer()
            Text(ShowPortfolio ? "Portfolio":"Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: ShowPortfolio ? -180:0))//antiClockWise
                .onTapGesture {
                    withAnimation(.spring()){
                        ShowPortfolio.toggle()
                    }
                }
            
            
        }//Hstack Header
        .padding(.horizontal)
    }
    
    private var portfolioEmptyView: some View {
        Text("No Coins Found, Press on the + button to Start your Portfolio🧐")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(40)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                    CoinRowView(coin: coin, showHoldeningsColumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .onTapGesture {
                            segue(coin: coin)
                        }
                        .listRowBackground(Color.theme.background)
                
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin:CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.PortfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldeningsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var headBar: some View {
        HStack{
            
            HStack(spacing: 4) {
                Text("coin")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank}
            }

            Spacer()
            if ShowPortfolio {
                HStack(spacing: 4) {
                    Text("holdings")
                    Image(systemName: "chevron.down")
                        .opacity( (vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings}
                }

            }
            HStack(spacing: 4) {
                Text("price")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.3,alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price}
            }
            
            
            Button (action : {
                withAnimation(.linear(duration: 0.5)) {
                    vm.reloadData()
                }
            },label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0),anchor: .center)

            
        }
        .font(.caption)
        .foregroundColor(Color.theme.seconderyText)
        .padding(.horizontal)
    }
}
