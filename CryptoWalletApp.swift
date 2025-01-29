//
//  CryptoWalletApp.swift
//  CryptoWallet
//
//  Created by pcpos on 16/12/2024.
import SwiftUI
@main
struct CryptoWalletApp: App {
    @StateObject private var vm = HomeViewModel()
    @State private var showLoadingView: Bool = true

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationSplitViewStyle(.balanced)
                .environmentObject(vm)
                
                if showLoadingView {
                    LaunchView(showLoadingView: $showLoadingView)
                        .transition(.move(edge: .leading))
                        .zIndex(2.0)
                }
            }
        }
    }
}
