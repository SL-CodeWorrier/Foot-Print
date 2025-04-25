//
//  Foot_PrintApp.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-03-15.
//

import SwiftUI

@main
struct Foot_PrintApp: App {
    
    init(){
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared);
            //EditProfileView()
        }
    }
}
