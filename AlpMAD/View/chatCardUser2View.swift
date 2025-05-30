//
//  chatCardUser2View.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import SwiftUI

struct chatCardUser2View: View {
    
    let message: Chat
    
    var body: some View {
        ZStack {
            HStack {
                Text(
                    message.message
                )
                .foregroundColor(.gray)
                .padding(10)
                .background(Color(hex: "#A0D2EB"))
                .cornerRadius(20)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // skip leading "#"

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    chatCardUser2View(message: Chat(id: "2", chatId: "1", message: "Hi!", time: Date(), senderId: "2", receiveId: "1"))
}
