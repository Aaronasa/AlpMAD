import SwiftUI

struct UserChatCardView: View {
    
    let chat: ListUserChat
    
    var body: some View {
        Divider()
            .frame(height: 1)
            .background(Color.gray)

        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(chat.username)
                        .fontWeight(.bold)
                        .foregroundColor(.black) // ← warna teks hitam
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
                    .foregroundColor(.black) // ← warna teks hitam
                    .opacity(0.6)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white) // ← latar belakang putih

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
