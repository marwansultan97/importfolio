//
//  FirebaseAuth.swift
//  importfolio
//
//  Created by Marwan Osama on 17/09/2021.
//

import Foundation
import Firebase


class FirebaseAuth {
    
    private let auth = Auth.auth()
    
    func signup(email: String, password: String, completion: @escaping(Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func signin(email: String, password: String, completion: @escaping(Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func signout(completion: @escaping(Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    
    func changePassword(newPassword: String, completion: @escaping(Error?) -> Void) {
        auth.currentUser?.updatePassword(to: newPassword, completion: { error in
            if error != nil { completion(error) }
            else { completion(nil) }
        })
    }
    
    func resetPassword(email: String, completion: @escaping(Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if error != nil { completion(error) }
            else { completion(nil) }
        }
    }
    
}
