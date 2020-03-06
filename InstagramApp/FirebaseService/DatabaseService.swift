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
    
    public func createItem(itemName: String, details: String, displayName: String, completion: @escaping (Result<Bool,Error>) ->()) {
        guard let user = Auth.auth().currentUser else { return  }
        
        let documentRef = db.collection(DatabaseService.itemsCollection).document()
        
        /*
         let image: UIImage
         let itemName: String
         let details: String
         let id: String
         */
        
        
        db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["itemName" :itemName,
            "details":details,
            "id":documentRef.documentID,
            "listedDate":Timestamp(date: Date()),
            "postedBy":displayName,
            "postedById":user.uid]) { (error) in
                if let error = error {
                    completion(.failure(error ))
                } else {
                    completion(.success(true))
                }
                
        }
    }
    
    //
    //  static let itemsCollection = "items" // collection
    //
    //    // let's get a reference to the Firebase Firestore database
    //
    //    private let db = Firestore.firestore()
    //
    ////    public func createItem(itemName: String, price: Double, category: Category, displayName: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    ////      guard let user = Auth.auth().currentUser else { return }
    ////
    ////      let documentRef = db.collection(DatabaseService.itemsCollection).document()
    ////
    ////
    ////
    ////      db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["itemName":itemName,"price": price, "itemId":documentRef.documentID, "listedDate": Timestamp(date: Date()), "sellerName": displayName,"sellerId": user.uid, "categoryName": category.name]) { (error) in
    ////        if let error = error {
    ////          completion(.failure(error))
    ////        } else {
    ////          completion(.success(true))
    ////        }
    ////      }
    ////
    ////    }
    //
    //}
}
