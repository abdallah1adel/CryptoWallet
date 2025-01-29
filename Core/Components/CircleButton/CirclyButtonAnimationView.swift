//
//  CirclyButtonAnimationView.swift
//  CryptoWallet
//
//  Created by pcpos on 20/12/2024.
//

import SwiftUI

struct CirclyButtonAnimationView: View {
    @Binding var animation: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animation ? 1.0 : 0.0)
            .opacity(animation ? 0.0 : 0.1)
            .animation(animation ? Animation.easeOut(duration: 0.1) : .none)
//            .onAppear {
//                animation.toggle()
//            }
    }
}

#Preview {
    CirclyButtonAnimationView(animation: .constant(false) )
        .foregroundColor(.red)
        .frame(width: 100, height: 100)
}
