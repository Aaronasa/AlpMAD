//
//  AlpMADApp.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 17/05/25.
//

import Firebase
import FirebaseAppCheck
import SwiftUI

@main
struct AlpMADApp: App {
    
    @StateObject var authVM = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
        #if DEBUG
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authVM)
        }
    }
}
