//
//  ImagePicker.swift
//  importfolio
//
//  Created by Marwan Osama on 24/09/2021.
//

import UIKit
import Photos


class ImagePicker: NSObject {
    
    static let shared = ImagePicker()
    private var currentVC: UIViewController!
    var imagePickedBlock: (([UIImagePickerController.InfoKey : Any]) -> Void)?
    
    private func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imageController = UIImagePickerController()
            imageController.delegate = self
            imageController.sourceType = .camera
            imageController.allowsEditing = true
            currentVC.present(imageController, animated: true)
        }
    }
    
    private func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = false
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        currentVC.present(actionSheet, animated: true)
    }
    
    func getImage(info: [UIImagePickerController.InfoKey : Any])-> UIImage {
        if let editedImage = info[.editedImage] as? UIImage {
            return editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            return originalImage
        } else {
            print("Something went wrong")
        }
        return UIImage()
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePickedBlock?(info)
        currentVC.dismiss(animated: true, completion: nil)
    }
    
}
