//
//  FirebaseStorage.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let itemsCollection = "items "
    
    private let db = Firestore.firestore()
    
    public func createItem(itemName: String, details: String, displayName: String, completion: @escaping (Result<String,Error>) ->()) {
        guard let user = Auth.auth().currentUser else { return  }
        
        let documentRef = db.collection(DatabaseService.itemsCollection).document()
        db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["itemName" :itemName,
            "details":details,
            "id":documentRef.documentID,
            "listedDate":Timestamp(date: Date()),
            "postedBy":displayName,
            "postedById":user.uid]) { (error) in
                if let error = error {
                    completion(.failure(error ))
                } else {
                    completion(.success(documentRef.documentID))
                }
                
        }
    }
}
