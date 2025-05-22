//
//  dateCardView.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import SwiftUI

struct dateCardView: View {
    var body: some View {
        ZStack {
            HStack {
                Text(
                    "20 May"
                )
                .foregroundColor(.black)
                .padding(10)
                .padding([.trailing, .leading], 15)
                .background(Color(hex: "#F8E9A1"))
                .cornerRadius(20)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    dateCardView()
}
