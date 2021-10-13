//
//  StorageService.swift
//  importfolio
//
//  Created by Marwan Osama on 25/09/2021.
//

import Foundation
import Firebase


class StorageService {
    
    static let shared = StorageService()
    private let ref = Storage.storage().reference()
    
    typealias uploadCompletion = ((String?, Error?) -> Void)
    
    private init() { }
    
    func uploadImage(uiimage: UIImage, child: String, completion: @escaping uploadCompletion, completionS: @escaping(Double) -> Void) {
        guard let email = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        guard let imageData = uiimage.pngData() else { print("No Image Data"); return }
        let uploadTask = ref.child("\(email)/\(child)").putData(imageData, metadata: nil) { meta, error in
            guard error == nil else { completion(nil, error) ; return}
            self.getURL(child: "\(email)/\(child)") { url, error in
                guard error == nil else { completion(nil, error) ; return}
                completion(url,nil)
            }
        }
        self.getProgress(task: uploadTask) { progress in
            completionS(progress)
        }

    }
    
    private func getURL(child: String, completion: @escaping(String?, Error?) -> Void) {
        ref.child(child).downloadURL { url, error in
            guard error == nil else { completion(nil, error) ; return }
            completion(url?.absoluteString, nil)
        }
    }
    
    private func getProgress(task: StorageUploadTask, completion: @escaping(Double) -> Void) {
        task.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            completion(percentComplete)
        }
        
        task.observe(.success) { _ in
            task.removeAllObservers()
        }
    }
    
    func deleteImage(child: String, completion: @escaping(Error?) -> Void) {
        guard let email = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        ref.child("\(email)/\(child)").delete { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
}
