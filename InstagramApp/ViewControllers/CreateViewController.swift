//
//  CreateViewController.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class CreateViewController: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var uploadingImage: UIImageView!
    private let dbService = DatabaseService()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func uploadPicPressed(_ sender: UIButton) {
        
        guard let itemName = nameTextfield.text,
            !itemName.isEmpty else {
                showAlert(title: "Missing fields", message: "please enter the item name/detail")
                return
        }
        guard let details = detailTextView.text,
        !details.isEmpty else {
                showAlert(title: "Missing fields", message: "please enter the item name/detail")
                return
        }
        guard let displayName = Auth.auth().currentUser?.displayName  else {
            showAlert(title: "Incomplete profile", message: "Please create a user profile first")
            return
        }
        
        let feedView = FeedViewController()
        
        dbService.createItem(itemName: itemName, details: details, displayName: displayName) { [weak self] (result) in
            switch result{
            case .failure(let error):
                self?.showAlert(title: "Failed upload", message: "error uploading item: \(error.localizedDescription)")
            case .success:
                self?.showAlert(title: nil, message: "Successfully listed item! 🥳")
            }
        }
        
        present(feedView, animated: true)
    }
    
    
}
