//
//  ProfileViewController.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var updatePhotoButton: UIButton!
    
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
        displayNameLabel.text = ""
        updateUI()
        backgroundImage.image = UIImage(named: "profileBack")
        profileImageView.layer.cornerRadius = 30
        updatePhotoButton.layer.cornerRadius = 30
    }
    
    private func updateUI(){
        guard let user = Auth.auth().currentUser else { return }
        profileImageView.kf.setImage(with: user.photoURL)
        displayNameLabel.text = "Welcome back, \(user.displayName ?? "")!"
    }
    
    @IBAction func updatePhotoPressed(_ sender: UIButton) {
          let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
          let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
          }
          let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
          }
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
          }
          alertController.addAction(photoLibraryAction)
          alertController.addAction(cancelAction)
          present(alertController, animated: true)
        }
     
    @IBAction func updateProfilePressed(_ sender: UIButton) {
            guard let displayName = self.displayNameTextField.text,
                !displayName.isEmpty,
                let selectedImage = self.selectedImage else {
                    displayNameLabel.text = "Welcome, \(displayNameTextField.text ?? "")!"
                    return
            }
            
            guard let user = Auth.auth().currentUser else { return }
            let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: self.profileImageView.bounds)
            self.storageService.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
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
