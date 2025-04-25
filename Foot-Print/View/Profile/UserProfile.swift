//
//  UserProfile.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-17.
//

import SwiftUI

struct UserProfile: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    @State var offset: CGFloat = 0
    @State var titleOffset: CGFloat = 0
    @State var currentTab = "Footprints"
    @State var tabBarOffset: CGFloat = 0
    @State var editProfileShow: Bool = false
    
    @Namespace var animation
    
    let user: User
    
    var isCurrentUser: Bool {
        return viewModel.user.isCurrentUser ?? false
    }
    
    var isFollowed: Bool{
        return viewModel.user.isFollowed ?? false
    }
    
    init(user: User){
        self.user = user
        self.viewModel = ProfileViewModel(user: user)
        print("USER: \(viewModel.user.isCurrentUser)")
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .global).minY
                    
                    ZStack {
                        Image("banner")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: getRect().width, height: minY > 0 ? 180 + minY : 180)
                            .cornerRadius(0)
                        
                        BlurView()
                            .opacity(blurViewOpacity())
                        
                        VStack(spacing: 5) {
                            Text(self.user.username)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("150 footprints")
                                .foregroundColor(.white)
                        }
                        .offset(y: 120)
                        .offset(y: titleOffset > 100 ? 0 : -getTitleOffset())
                        .opacity(titleOffset < 100 ? 1 : 0)
                    }
                    .clipped()
                    .frame(height: minY > 0 ? 180 + minY : nil)
                    .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)
                    .background(
                        GeometryReader { innerProxy in
                            Color.clear
                                .preference(key: OffsetKey.self, value: innerProxy.frame(in: .global).minY)
                        }
                    )
                }
                .frame(height: 180)
                .zIndex(1)
                .onPreferenceChange(OffsetKey.self) { value in
                    self.offset = value
                }
                
                VStack {
                    HStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .padding(8)
                            .background(Color.white.clipShape(Circle()))
                            .offset(y: offset < 0 ? getOffset() - 20 : -20)
                            .scaleEffect(getScale())
                        
                        Spacer()
                        
                        if(self.isCurrentUser){
                            Button(action: {
                                self.editProfileShow.toggle()
                            }) {
                                Text("Edit Profile")
                                    .foregroundColor(.blue)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Capsule().stroke(Color.blue, lineWidth: 1.5))
                            }
                            .sheet(isPresented: $editProfileShow) {
                                EditProfileView(user: $viewModel.user)
                            }
                        }
                        else{
                            Button(action: {
                                isFollowed ? self.viewModel.unfollow() : self.viewModel.follow()
                            }) {
                                Text(isFollowed ? "following" : "Follow")
                                    .foregroundColor( isFollowed ? .blue : Color.gray)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Capsule().stroke( isFollowed ? .blue : Color.gray, lineWidth: 1.5))
                            }
                            .sheet(isPresented: $editProfileShow) {
                                EditProfileView(user: $viewModel.user)
                            }
                        }
                    }
                    .padding(.top, -25)
                    .padding(.bottom, -10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(self.user.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("@\(self.user.username)")
                            .foregroundColor(.gray)
                        
                        Text("I want the best love story in the world to be written in the name of me and nature.")
                        
                        HStack(spacing: 5) {
                            Text("13")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                            
                            Text("Followers")
                                .foregroundColor(.gray)
                            
                            Text("680")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                                .padding(.leading, 10)
                            
                            Text("Following")
                                .foregroundColor(.gray)
                        }
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: TitleOffsetKey.self, value: proxy.frame(in: .global).minY)
                        }
                    )
                    .onPreferenceChange(TitleOffsetKey.self) { value in
                        self.titleOffset = value
                    }
                    
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                TabButton(title: "Footprints", currentTab: $currentTab, animation: animation)
                                TabButton(title: "Footprints & Likes", currentTab: $currentTab, animation: animation)
                                TabButton(title: "Media", currentTab: $currentTab, animation: animation)
                                TabButton(title: "Likes", currentTab: $currentTab, animation: animation)
                            }
                        }
                        Divider()
                    }
                    .padding(.top, 30)
                    .background(Color.white)
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: TabBarOffsetKey.self, value: proxy.frame(in: .global).minY)
                        }
                    )
                    .onPreferenceChange(TabBarOffsetKey.self) { value in
                        self.tabBarOffset = value
                    }
                    .offset(y: tabBarOffset < 90 ? -tabBarOffset + 90 : 0)
                    .zIndex(1)
                    
                    VStack(spacing: 18) {
                        // Your postCaptionCellView and other content
                        ForEach(viewModel.tweets) { tweet in
                            postCaptionCellView(viewModel: TweetCellViewModel(tweet: tweet, currentUser: user))
                                .onAppear {
                                    print("🌀 In the user profile tweet loop now")
                                    print(tweet)
                                }
                        }
                    }
                    .padding(.top, 100)
                    .zIndex(0)
                }
                .padding(.horizontal)
                .zIndex(-offset > 80 ? 0 : 1)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
    
    func blurViewOpacity() -> Double {
        let progress = -(offset + 80) / 150
        return Double(-offset > 80 ? progress : 0)
    }
    
    func getTitleOffset() -> CGFloat {
        let progress = 20 / titleOffset
        let offset = 60 * (progress > 0 && progress <= 1 ? progress : 1)
        return offset
    }
    
    func getOffset() -> CGFloat {
        let progress = (-offset / 80) * 80
        return progress <= 20 ? progress : 20
    }
    
    func getScale() -> CGFloat {
        let progress = -offset / 80
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        return scale < 1 ? scale : 1
    }
}

// MARK: - Preference Keys
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TitleOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TabBarOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
