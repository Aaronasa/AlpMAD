//
//  UserChatCardView.swift
//  AlpMAD
//
//  Created by student on 22/05/25.
//

import SwiftUI

struct UserChatCardView: View {
    var body: some View {
        Divider()
            .frame(height: 1)
            .background(Color.blue)

        HStack{
            VStack{
                HStack{
                    Text("Anonymous")
                        .fontWeight(.bold)
                    Spacer()
                    Text("7:06 PM")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("Lorem ipsum dolor sit amet consectetur adipisicing elit. Quo, voluptatem!")
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
            .background(Color.blue)
    }
}

#Preview {
    UserChatCardView()
}
