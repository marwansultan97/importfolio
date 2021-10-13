//
//  AuthenticationRepo.swift
//  importfolio
//
//  Created by Marwan Osama on 17/09/2021.
//

import Foundation
import Firebase

protocol AuthenticationRepo {
    func signin(email: String, password: String, completion: @escaping(Error?) -> Void)
    func signup(personalModel: PersonalInfosModel, password: String, completion: @escaping(Error?) -> Void)
    func signout(completion: @escaping(Error?) -> Void)
    func resetPassword(email: String, completion: @escaping(Error?) -> Void)
    func changePassword(newPassword: String, completion: @escaping(Error?) -> Void)
}

class AuthenticationRepoImpl: AuthenticationRepo {
    
    let firebaseAuth = FirebaseAuth()
    
    func signin(email: String, password: String, completion: @escaping (Error?) -> Void) {
        firebaseAuth.signin(email: email, password: password) { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    func signup(personalModel: PersonalInfosModel, password: String, completion: @escaping (Error?) -> Void) {
        firebaseAuth.signup(email: personalModel.email, password: password) { error in
            if error != nil {
                completion(error)
            } else {
                self.saveUserInfos(personalModel: personalModel) { error in
                    if error != nil {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    private func saveUserInfos(personalModel: PersonalInfosModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        FirebaseService.shared.write(uid: uid, object: personalModel, child: FirebaseCollections.personal.rawValue) { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func signout(completion: @escaping (Error?) -> Void) {
        firebaseAuth.signout { error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func changePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        firebaseAuth.changePassword(newPassword: newPassword) { error in
            if error != nil { completion(error) }
            else { completion(nil) }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        firebaseAuth.resetPassword(email: email) { error in
            if error != nil { completion(error) }
            else { completion(nil) }
        }
    }
    
    
}
