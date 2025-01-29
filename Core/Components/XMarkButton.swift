//
//  XMarkButton.swift
//  CryptoWallet
//
//  Created by pcpos on 03/01/2025.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.dismiss) var dismiss
        @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button(action: {
//            dismiss() // Dismiss the current view
                       presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}

