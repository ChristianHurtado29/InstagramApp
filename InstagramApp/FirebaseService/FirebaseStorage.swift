//
//  FirebaseStorage.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DatabaseService {
    
  static let itemsCollection = "items" // collection
    
    // let's get a reference to the Firebase Firestore database
    
    private let db = Firestore.firestore()
    
//    public func createItem(itemName: String, price: Double, category: Category, displayName: String, completion: @escaping (Result<Bool, Error>) -> ()) {
//      guard let user = Auth.auth().currentUser else { return }
//
//      let documentRef = db.collection(DatabaseService.itemsCollection).document()
//
//
//
//      db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["itemName":itemName,"price": price, "itemId":documentRef.documentID, "listedDate": Timestamp(date: Date()), "sellerName": displayName,"sellerId": user.uid, "categoryName": category.name]) { (error) in
//        if let error = error {
//          completion(.failure(error))
//        } else {
//          completion(.success(true))
//        }
//      }
//
//    }
    
}
