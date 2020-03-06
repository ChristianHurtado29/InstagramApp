//
//  ProfileViewController.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    private lazy var imagePickerController: UIImagePickerController = {
      let ip = UIImagePickerController()
      ip.delegate = self
      return ip
    }()
    
    private var selectedImage: UIImage? {
      didSet {
        profileImageView.image = selectedImage
      }
    }
    
    private let storageService = StorageService()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func updateProfilePressed(_ sender: UIButton) {
        {
          guard let displayName = displayNameTextField.text,
            !displayName.isEmpty,
            let selectedImage = selectedImage else {
              print("missing fields")
              return
          }
          
          guard let user = Auth.auth().currentUser else { return }
          
          // resize image before uploading to Firebase
          let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profileImageView.bounds)
          
          print("original image size: \(selectedImage.size)")
          print("resized image size: \(resizedImage)")
          
          // call storageService.upload
          storageService.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
            // code here to add the photoURL to the user's photoURL property then commit changes
            switch result {
            case .failure(let error):
              DispatchQueue.main.async {
                self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
              }
            case .success(let url):
              let request = Auth.auth().currentUser?.createProfileChangeRequest()
              request?.displayName = displayName
              request?.photoURL = url
              request?.commitChanges(completion: { [unowned self] (error) in
                if let error = error {
                  DispatchQueue.main.async {
                    self?.showAlert(title: "Error updating profile", message: "Error changing profile: \(error.localizedDescription).")
                  }
                } else {
                  DispatchQueue.main.async {
                    self?.showAlert(title: "Profile Update", message: "Profile successfully updated 🥳.")
                  }
                }
              })
            }
            
          }
          
          

        }
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            UIViewController.showViewController(storyboardName: "LoginView", viewControllerId: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
            }
        }
    }

    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      return
    }
    selectedImage = image
    dismiss(animated: true)
  }
}
