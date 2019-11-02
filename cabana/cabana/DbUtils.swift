//
//  DbUtils.swift
//  cabana
//
//  Created by Kishan on 10/6/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Foundation
import Firebase

class DbUtils {
    static func addUsers() {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        for _ in 0..<15 {
            ref = db.collection("users").addDocument(data: [
                "first": DbUtils.randomString(length: 5),
                "last": DbUtils.randomString(length: 7),
                "born": 1815
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
    static func addRooms() {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        for _ in 0..<5 {
            ref = db.collection("room").addDocument(data: [
                "name": DbUtils.randomString(length: 5),
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
        
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyz"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
