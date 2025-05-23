//
//  EditProfileView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-24.
//

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    
    @Binding var user: User
    
    @State var profileImage: Image?
    @State private var selectedImage: UIImage?
    @State var imagePickerPresented = false;
    
    @State var name: String
    @State var location: String
    @State var bio: String
    @State var website: String
    
    @Environment(\.presentationMode) var mode
    
    @ObservedObject var viewModel: EditProfileViewModel
    
    init(user: Binding<User>){
        self._user = user
        self._name = State(initialValue: self._user.name.wrappedValue ?? "")
        self._location = State(initialValue: self._user.location.wrappedValue ?? "")
        self._bio = State(initialValue: self._user.bio.wrappedValue ?? "")
        self._website = State(initialValue: self._user.website.wrappedValue ?? "")
        self.viewModel = EditProfileViewModel(user: self._user.wrappedValue)
    }
    
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    Button {
                        print("Cancel button tapped!")
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button {
                        print("Save button tapped!")
                        if (selectedImage != nil){
                            self.viewModel.uploadProfileImage(text: "text", image: selectedImage)
                            self.viewModel.uploadUserData(name: name, bio: bio, website: website, location: location)
                            KingfisherManager.shared.cache.clearCache()
                        }
                        else{
                            self.viewModel.uploadUserData(name: name, bio: bio, website: website, location: location)
                        }
                    } label: {
                        Text("Save")
                            .foregroundColor(.black)
                    }

                }
                .padding()
                
                HStack{
                    Spacer()
                    Text("Edit Profile")
                        .fontWeight(.heavy)
                    Spacer()
                }
            }
            
            VStack{
                Image("banner")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 108, alignment: .center)
                    .cornerRadius(0)
                
                HStack{
                    if profileImage == nil{
                        Button {
                            self.imagePickerPresented.toggle();
                        } label: {
                            KFImage(URL(string: "https://foot-print-api.up.railway.app/users/id/avater"))
                                .resizable()
                                .placeholder(){
                                    Image("blankpp")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 75, height: 75)
                                        .clipShape(Circle())
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(y: -20)
                                .padding(.leading, 12)
                        }
                        .sheet(isPresented: $imagePickerPresented){
                            loadImage()
                        }
                        content : {
                            ImagePicker(image: $selectedImage)
                        }
                    }
                    else if let image = profileImage {
                        VStack{
                            HStack(alignment: .top) {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 75, height: 75)
                                    .clipShape(Circle())
                                    .padding(8)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .offset(y: -20)
                            }
                            .padding()
                        }
                        .padding(.leading, 12)
                    }
                    Spacer()
                }
                .onAppear(){
                    KingfisherManager.shared.cache.clearCache()
                }
                .padding(.top, -20)
                .padding(.bottom, -10)
                
                VStack{
                    Divider()
                    HStack{
                        ZStack{
                            HStack{
                                Text("Name")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            CustomProfileTextField(message: $name, placeholder: "Add your name")
                                .padding(.leading, 90)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    HStack{
                        ZStack{
                            HStack{
                                Text("Location")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            CustomProfileTextField(message: $location, placeholder: "Add your location")
                                .padding(.leading, 90)
                        }
                    }
                    .padding(.horizontal)
                    
                    /*
                    Divider()
                    
                    HStack{
                        ZStack(alignment: .topLeading) {
                            HStack{
                                Text("Bio")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            
                            CustomProfileBioTextField(bio: $bio)
                                .padding(.leading, 86)
                                .padding(.top, -6)
                        }
                    }
                    .padding(.horizontal)
                     */
                    
                    Divider()
                    HStack{
                        ZStack{
                            HStack{
                                Text("bio")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            CustomProfileTextField(message: $bio, placeholder: "Add your bio")
                                .padding(.leading, 90)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    HStack{
                        ZStack{
                            HStack{
                                Text("website")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            CustomProfileTextField(message: $website, placeholder: "Add your website")
                                .padding(.leading, 90)
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
            Spacer()
        }
        .onReceive(viewModel.$uploadComplete) { complete in
            if complete {
                self.mode.wrappedValue.dismiss()
                
                self.user.name = viewModel.user.name
                self.user.website = viewModel.user.website
                self.user.bio = viewModel.user.bio
                self.user.location = viewModel.user.location
            }
        }
    }
}

extension EditProfileView {
    func loadImage(){
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
}
