//
//  Extensions.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-14.
//

import UIKit
import SwiftUI 

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}
