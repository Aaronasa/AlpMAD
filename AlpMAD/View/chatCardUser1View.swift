//
//  chatCardUser1View.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import SwiftUI

struct chatCardUser1View: View {
    var body: some View {
        ZStack {
            HStack {
                Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vel semper sapien. Etiam bibendum, nunc sed."
                )
                .foregroundColor(.white)
                .padding(10)
                .background(Color(hex: "#4A90E2"))
                .cornerRadius(20)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
        }
    }
}



#Preview {
    chatCardUser1View()
}
