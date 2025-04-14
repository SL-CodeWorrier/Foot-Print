//
//  SearchUserCell.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-14.
//

import SwiftUI

struct SearchUserCell: View {
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("Solo")
                    .fontWeight(.heavy)
                Text("@solo_hiker")
            }
            
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    SearchUserCell()
}
