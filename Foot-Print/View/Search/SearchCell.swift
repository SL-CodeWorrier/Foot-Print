//
//  SearchCell.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-14.
//

import SwiftUI

struct SearchCell: View {
    
    var tag = ""
    var footPrints = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text("hello").fontWeight(.heavy)
            Text(footPrints + " footprints").fontWeight(.light)
        })
    }
}

#Preview {
    SearchCell()
}
