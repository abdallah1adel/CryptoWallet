//
//  SettingsView.swift
//  CryptoWallet
//
//  Created by pcpos on 08/01/2025.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com")!
    let swiffulThinkingURL = URL(string: "https://swiftfulthinking.com")!
    
    var body: some View {
        
        NavigationView {
            ZStack(content: {
                //background layer
                Color.theme.background
                    .edgesIgnoringSafeArea(.all)
                
                //content layer
                List {
                    CreditSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    CoinGecko
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    DeveloperSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    developStage
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }
            })
            .font(.subheadline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle(Text("Settings"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
        
    }
}

#Preview {
    SettingsView()
}



extension SettingsView {
    private var CreditSection: some View {
        
        Section {
            VStack {
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Text("THis is a Crypto Wallet app with the coin geko API for daily updates of crypto prices, made based on MVVM architecture using coreDate and combine following swiftful thinking")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.theme.accent)
                }
            }
            .padding(.vertical)
            Link("youtube tutorial ", destination: swiffulThinkingURL)
            
        } header: {Text("Credit") }
    }
    
    
    private var CoinGecko: some View {
        
        Section {
            VStack {
                VStack {
                    Image("coingecko")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Text("coin gecko's API provides real time updates of crypto prices")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.theme.accent)
                }
            }
            .padding(.vertical)
            Link("Visit coin gecko", destination: coinGeckoURL)
            
        } header: {Text("Coin Gecko") }
    }
    private var DeveloperSection: some View {
        
        Section {
            VStack {
                VStack {
//                    Image("logo")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 100)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Text("Third app and first in 2025 to be deployed using API and MVVM archeticture to graph some data in statistical charts and provide real time updates of crypto prices which you can add and see your coins status and sort or serach for specific coins... more to be done and great days are ahead watch the sky")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.theme.accent)
                }
            }
            .padding(.vertical)
            
        } header: {Text("Story") }
    }
    
    private var developStage: some View {
        
        Section {
            HStack {
                VStack(alignment: .leading) {
                    Link("Company Website", destination: defaultURL)
                    Divider()
                    Link("License Agreement", destination: defaultURL)
                }
                Divider()
                VStack(alignment: .leading) {
                    Link("Privacy Policy", destination: defaultURL)
                    Divider()
                    Link("Terms of Service", destination: defaultURL)
                }
            }
 
        } header: {Text("Application") }
    }
}
