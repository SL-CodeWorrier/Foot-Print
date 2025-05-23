//
//  SlideMenu.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-14.
//

import SwiftUI

struct SlideMenu: View {
    
    @ObservedObject var viewModel: AuthViewModel
    @State var show = false
    @State private var isAuthenticated = true
    
    var menuButtons = ["Profile", "Lists", "Topics", "Bookmarks", "Moments"]
    
    var edges = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
        .windows
        .first(where: { $0.isKeyWindow })?
        .safeAreaInsets
    
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            HStack(spacing: 0, content: {
                
                VStack(alignment: .leading, content: {
                    
                    NavigationLink (destination: UserProfile(user: viewModel.currentUser!)) {
                        Image("logo")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }

                    
                    HStack(alignment: .top, spacing: 12, content: {
                        
                        VStack(alignment: .leading, spacing: 12, content: {
                            NavigationLink(destination: UserProfile(user: viewModel.currentUser!)){
                                Text(viewModel.currentUser?.name ?? "")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            
                            Text("@\(viewModel.currentUser?.username ?? "")")
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 20, content: {
                                
                                FollowView(count: 8, title: "Following")
                                
                                FollowView(count: 16, title: "Followers")
                            })
                            .padding(.top, 10)
                            
                            Divider()
                                .padding(.top, 10)
                        })
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            withAnimation {
                                self.show.toggle()
                            }
                        }, label: {
                            Image(systemName: show ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color("bg"))
                        })
                        
                    })
                    
                    VStack(alignment: .leading, content: {
                        
                        ForEach(menuButtons, id:\.self) { item in
                            NavigationLink(destination: UserProfile(user: viewModel.currentUser!)){
                                MenuButton(title: item)
                            }
                        }
                        
                        Divider()
                            .padding(.top)
                        
                        Button(action: {
                            
                        }, label: {
                            MenuButton(title: "Footprint Ads")
                        })
                        
                        Divider()
                        
                        Button(action: {
                            
                        }, label: {
                            Text("Settings and privacy")
                                .foregroundColor(.black)
                        })
                        .padding(.top, 20)
                        
                        Button(action: {
                            
                        }, label: {
                            Text("Help centre")
                                .foregroundColor(.black)
                        })
                        .padding(.top, 0)
                        
                        if isAuthenticated {
                                        // Your HomeView content here
                                        
                                        Button(action: {
                                            self.viewModel.logout()
                                            // After logging out, set isAuthenticated to false
                                            DispatchQueue.main.async {
                                                self.isAuthenticated = false
                                            }
                                        }, label: {
                                            Text("Logout")
                                                .foregroundColor(.red)
                                        })
                                        .padding(.top, 10)
                                    } else {
                                        // When not authenticated, show LoginView
                                        LoginView() // Assuming this is your login screen view
                                    }
                        
                        Spacer(minLength: 0)
                        
                        Divider()
                            .padding(.bottom)
                        
                        HStack {
                            Button(action: {
                                
                            }, label: {
                                Image("help")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color("bg"))
                            })
                            
                            Spacer(minLength: 0)
                            
                            Image("barcode")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("bg"))
                            
                        }
                    })
                    .opacity(show ? 1 : 0)
                    .frame(height: show ? nil : 0)
                    
                    VStack(alignment: .leading, content: {
                        Button(action: {
                            
                        }, label: {
                            Text("Create a new account")
                                .foregroundColor(Color("bg"))
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            Text("Add an existing account")
                                .foregroundColor(Color("bg"))
                        })
                        
                        Spacer(minLength: 0)
                    })
                    .opacity(!show ? 1 : 0)
                    .frame(height: !show ? nil : 0)
                    
                })
                .padding(.horizontal, 20)
                .padding(.top, edges!.top == 0 ? 15 : edges?.top)
                .padding(.bottom, edges!.bottom == 0 ? 15 : edges?.bottom)
                //.frame(width: width - 40)
                .frame(width: 300)
                .background(Color.white)
                .ignoresSafeArea(.all, edges: .vertical)
                
                Spacer(minLength: 0)
            })
        }
    }
}
