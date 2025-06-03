//
//  AlpMADMacApp.swift
//  AlpMADMac
//
//  Created by Aaron Asa Soelistiono on 01/06/25.
//

import Firebase
import FirebaseAppCheck
import SwiftUI

@main
struct AlpMADMacApp: App {
    
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
