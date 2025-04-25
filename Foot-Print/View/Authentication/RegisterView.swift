//
//  RegisterView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-20.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() 
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    })
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Image("footprint")
                    .resizable()
                    .scaledToFill()
                    .padding(.trailing)
                    .frame(width: 30, height: 30)
            }
            
            Text("Create your account")
                .font(.title)
                .bold()
                .padding(.top, 35)
            
            VStack(alignment: .leading, spacing: nil, content: {
                CustomAuthTextField(placeholder: "Name", text: $name)
                
                CustomAuthTextField(placeholder: "Phone number or email", text: $email)
                CustomAuthTextField(placeholder: "Password", text: $password)
                
            })
            
            Spacer(minLength: 0)
            
            VStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.viewModel.register(name: name, username: name, email: email, password: password)
                        
                    }, label: {
                        Capsule()
                            .frame(width: 60, height: 30, alignment: .center)
                            .foregroundColor(Color(red: 29 / 255, green: 161 / 255, blue: 242 / 255))
                            .overlay(
                                Text("Next")
                                    .foregroundColor(.white)
                            )
                    })
                }
                .padding(.trailing, 24)
            }
        }
    }
}

#Preview {
    RegisterView()
}
