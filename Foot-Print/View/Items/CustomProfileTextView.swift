//
//  CustomProfileTextView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-24.
//

import SwiftUI

struct CustomProfileTextField: View {
  
  @Binding var message: String
  var placeholder: String

  var body: some View {
    HStack {
      ZStack {
        HStack {
            if message.isEmpty{
                Text(placeholder)
                  .foregroundColor(.gray)
            }
          Spacer()
        }

        TextField("", text: $message)
          .foregroundColor(.blue)
      }
    }
  }
}
