//
//  ProjectRepo.swift
//  importfolio
//
//  Created by Marwan Osama on 30/09/2021.
//

import Foundation
import UIKit
import Firebase

protocol ProjectsRepo {
    func changeAppImage(project: ProjectModel, image: UIImage, completion: @escaping(Error?) -> Void)
    func addImage(project: ProjectModel, id: String, image: UIImage, completion: @escaping(Error?) -> Void)
    func deleteImage(project: ProjectModel, imageModel: ImageModel, completion: @escaping(Error?) -> Void)
    func getProject(uid: String, id: String, completion: @escaping(ProjectModel?, Error?) -> Void)
    func getProjectImages(uid: String, project: ProjectModel, completion: @escaping([ImageModel]) -> Void)
}

class ProjectsRepoImpl: ProjectsRepo {
    
    
    func getProjectImages(uid: String, project: ProjectModel, completion: @escaping ([ImageModel]) -> Void) {
//        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.readList(uid: uid, object: ImageModel.self, child: "\(FirebaseCollections.projectImages.rawValue)/\(project.id)") { images in
            completion(images)
        }
    }
    
    
    func getProject(uid: String, id: String, completion: @escaping (ProjectModel?, Error?) -> Void) {
//        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.read(uid: uid, object: ProjectModel.self, child: "\(FirebaseCollections.projects)/\(id)") { error, project in
            if error != nil {
                completion(nil,error)
            } else {
                completion(project, nil)
            }
        }
    }
    
    
    func changeAppImage(project: ProjectModel, image: UIImage, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        StorageService.shared.uploadImage(uiimage: image, child: "\(FirebaseCollections.projects.rawValue)/\(project.id)/\("icon")") { url, error in
            if error != nil {
                completion(error)
            } else {
                guard let url = url else { return }
                FirebaseService.shared.writeValue(uid: uid, values: ["appImage": url], child: "\(FirebaseCollections.projects.rawValue)/\(project.id)") { error in
                    if error != nil { completion(error) }
                    else { completion(nil) }
                }
            }
        } completionS: { _ in}

    }

    
    func addImage(project: ProjectModel, id: String, image: UIImage, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        StorageService.shared.uploadImage(uiimage: image, child: "\(FirebaseCollections.projects.rawValue)/\(project.id)/\(id)") { url, error in
            if error != nil {
                completion(error)
            } else {
                guard let url = url else { return }
                FirebaseService.shared.writeValue(uid: uid, values: ["id" : id, "imageURL": url], child: "\(FirebaseCollections.projectImages.rawValue)/\(project.id)/\(id)") { error in
                    if error != nil { completion(error) }
                    else { completion(nil) }
                }
            }
        } completionS: { _ in}

    }
    
    func deleteImage(project: ProjectModel, imageModel: ImageModel, completion: @escaping(Error?) -> Void) {
        StorageService.shared.deleteImage(child: "\(FirebaseCollections.projects.rawValue)/\(project.id)/\(imageModel.id)") { error in
            if error != nil {
                completion(error)
            } else {
                FirebaseService.shared.delete(child: "\(FirebaseCollections.projectImages.rawValue)/\(project.id)/\(imageModel.id)") { error in
                    if error != nil { completion(error) }
                    else { completion(nil) }
                }
            }
        }
    }
    
    
}
