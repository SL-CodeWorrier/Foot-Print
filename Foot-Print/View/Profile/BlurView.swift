//
//  BlurView.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-17.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
