//
//  FirebaseService.swift
//  importfolio
//
//  Created by Marwan Osama on 18/09/2021.
//

import Foundation
import Firebase

class FirebaseService {
    
    static let shared = FirebaseService()
    private let ref = Database.database().reference()
    
    private init() { }
    
    func writeValue(uid: String, values: [AnyHashable: Any], child: String, completion: @escaping(Error?) -> Void) {
        ref.child("\(uid)/\(child)").updateChildValues(values) { error, _ in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func write<T: Codable>(uid: String, object: T, child: String, completion: @escaping(Error?) -> Void) {
        do {
            let json = try object.asDictionary()
            ref.child("\(uid)/\(child)").updateChildValues(json)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    func read<T: Codable>(uid: String, object: T.Type, child: String, completion: @escaping(Error?, T?) -> Void) {
        ref.child("\(uid)/\(child)").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), snapshot.value != nil else {
                completion(nil, nil)
                return }
            do {
                let object = try snapshot.decode(objectType: object)
                completion(nil,object)
            } catch let error {
                completion(error,nil)
            }
        }
    }
    
    func readList<T: Codable>(uid: String, object: T.Type, child: String, completion: @escaping([T]) -> Void) {
        ref.child("\(uid)/\(child)").observeSingleEvent(of: .value) { snapshot in
            let list = snapshot.decodeList(objectType: object)
            completion(list)

        }
    }
    
    func delete(child: String, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.email?.replaceDotWithComma() else { return }
        ref.child("\(uid)/\(child)").removeValue { error, _ in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
}
