//
//  UserChatCardView.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import SwiftUI

struct UserChatCardView: View {
    
    let chat: ListUserChat
    
    var body: some View {
        Divider()
            .frame(height: 1)
            .background(Color.gray)

        HStack{
            VStack(alignment: .leading){
                HStack{
                    Text(chat.username)
                        .fontWeight(.bold)
                    Spacer()
                    Text(chat.lastMessage != nil ? formattedTime(chat.lastMessage!.time) : "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text(chat.lastMessage?.message ?? "No message yet")
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.top, 5)
                    .font(.system(size: 14))
                    .opacity(0.6)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        
        Divider()
            .frame(height: 1)
            .background(Color.gray)
    }
    private func formattedTime(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
    
}

//#Preview {
//    UserChatCardView()
//}
