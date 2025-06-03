//
//  chatCardUser1View.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import SwiftUI

struct chatCardUser1View: View {
    
    let message: Chat
    
    var body: some View {
        ZStack {
            HStack {
                Text(
                    message.message
                    
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
    chatCardUser1View(message: Chat(id: "1", chatId: "1", message: "Hello", time: Date(), senderId: "1", receiveId: "2"))
}
