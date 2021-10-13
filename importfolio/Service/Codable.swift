//
//  Codable.swift
//  importfolio
//
//  Created by Marwan Osama on 18/09/2021.
//

import Foundation
import Firebase

extension DataSnapshot {
    
    func decode<T: Decodable>(objectType: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self.value!, options: [])
        let jsonObject = try JSONDecoder().decode(T.self, from: data)
        return jsonObject
    }
    
    func decodeList<T: Decodable>(objectType: T.Type) -> [T] {
        var list = [T]()
        guard self.exists(), self.value != nil else { return [] }
        for child in self.children {
            if let child = child as? DataSnapshot {
                if let object = try? child.decode(objectType: objectType) {
                    list.append(object)
                }
            }
        }
        return list
    }
    
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return [:] }
        return json
    }

    func toJson(excluding keys: [String] = []) throws -> [String: Any] {
    guard let objectData = try? JSONEncoder().encode(self) else {return [:]}
        guard var json = try? JSONSerialization.jsonObject(with: objectData, options: []) as? [String: Any] else {return [:]}
        for key in keys {
            json[key] = nil
        }
        return json
    }
}
