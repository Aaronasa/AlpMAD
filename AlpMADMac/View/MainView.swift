//
//  MainView.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 18/05/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var authVM = AuthViewModel()
//    @StateObject var postVM = PostViewModel()
//    @StateObject var replyVM = ReplyViewModel()

    var body: some View {
            if authVM.isLoggedIn {
                NavigationStack {
//                    ConfesView()
//                        .environmentObject(authVM)
//                        .environmentObject(postVM)
//                        .environmentObject(replyVM)
                }
            } else if authVM.showLogin {
                LoginView(showLogin: $authVM.showLogin)
                    .environmentObject(authVM)
            } else {
                RegisterView(showLogin: $authVM.showLogin)
                    .environmentObject(authVM)
            }
    }
}




#Preview {
    MainView()
        .environmentObject(AuthViewModel())
//        .environmentObject(PostViewModel())
//        .environmentObject(ReplyViewModel())
}
