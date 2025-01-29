//
//  LaunchView.swift
//  CryptoWallet
//
//  Created by pcpos on 08/01/2025.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText : [String] = "Loading...".map{String($0)}
    @State private var showLoadingText :Bool = false
    let timer = Timer.publish(every: 0.1, on: .main,in: .common).autoconnect()
    @State private var loadingTextIndex : Int = 0
    @State private var loops : Int = 0
    @Binding  var showLoadingView : Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
                
            ZStack {
//                Text(loadingText)

//                    .transition(AnyTransition.scale.animation(.easeInOut))
                HStack(spacing: 0) {
                    ForEach(loadingText.indices) { index in
                        Text(loadingText[index])
                                            .fontWeight(.heavy)
                                            .foregroundColor(Color.launch.accent)
                                            .font(.headline)
                                            .offset(y: loadingTextIndex == index ? -5 : 0)
                    }
                }
                
            }
            .offset(y: 70)
        }
        .onTapGesture {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                
                let lastIndex = loadingText.count - 1
                
                if loadingTextIndex == lastIndex {
                    loadingTextIndex = 0
                    loops += 1
                    if loops >= 4 {
                        showLoadingView = false
                    }
                } else {
                    loadingTextIndex += 1

                }
                
            }
        }
    }
}

#Preview {
    LaunchView(showLoadingView: .constant(true))
}
