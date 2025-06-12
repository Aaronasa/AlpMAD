//
//  dateCardView.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import SwiftUI

struct dateCardView: View {
    
    let date: Date
    
    var body: some View {
        ZStack {
            HStack {
                Text(
                    formatDate(date)
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
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            return formatter.string(from: date)
        }
}

#Preview {
    dateCardView(date: Date())
}
