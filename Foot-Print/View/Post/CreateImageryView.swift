//
//  CreateTweetView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-03-29.
//

import SwiftUI

struct CreateImageryView: View {
    
    @ObservedObject var viewModel = CreateTweetViewModel();
    
    @State var text = ""
    @State var imagePickerPresented: Bool = false;
    @State var selectedImage: UIImage?
    @State var postImage: Image?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("Cancel")
                })
                
                Spacer()
                
                Button(action: {
                    self.viewModel.uploadPost(text: text, image: selectedImage);
                }, label: {
                    Text("Write").padding()
                })
                .background(Color("bg"))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            
            MultilineTextField(text:  $text)
            
            if postImage == nil {
                Button {
                    self.imagePickerPresented.toggle();
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipped()
                        .padding(.top)
                        .foregroundColor(.black)
                }.sheet(isPresented: $imagePickerPresented) {
                    loadImage()
                } content: {
                    ImagePicker(image: $selectedImage)
                }
            }

            else if let image = postImage{
                VStack{
                    
                    HStack(alignment: .top){
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal)
                            .frame(width: 300)
                            .cornerRadius(16)
                            .clipped()
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
}

extension CreateImageryView {
    
    func loadImage(){
        guard let selectedImage = selectedImage else { return }
        
        postImage = Image(uiImage: selectedImage)
    }
}

#Preview {
    CreateImageryView()
}
