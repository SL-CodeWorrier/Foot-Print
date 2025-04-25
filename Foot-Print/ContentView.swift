//
//  ContentView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-03-15.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    var body: some View {
        if authViewModel.isauthenticated{
            if let user = authViewModel.currentUser{
                MainView(user: user);
            }
        }
        else{
            WelcomeView();
        }
    }
}

#Preview {
    ContentView()
}
