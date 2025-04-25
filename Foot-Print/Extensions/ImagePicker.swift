//
//  ImagePicker.swift
//  Foot-Print
//
//  Created by Chathura Aththanayaka on 2025-04-24.
//
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var mode  // ✅ Corrected syntax

    func makeCoordinator() -> Coordinator {
        Coordinator(self) // ✅ Class name should be spelled correctly
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // No updates needed here for this use-case
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.mode.wrappedValue.dismiss() // ✅ Corrected from 'wrapValue' to 'wrappedValue'
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.mode.wrappedValue.dismiss()
        }
    }
}
