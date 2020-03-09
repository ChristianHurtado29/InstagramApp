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
    private let storageService = StorageService()
    
    @IBOutlet weak var cancelButtonOut: UIButton!
    

    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(photoOptions))
        print("long pressing")
        return gesture
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            uploadingImage.image = selectedImage
            cancelButtonOut.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadingImage.isUserInteractionEnabled = true
        uploadingImage.addGestureRecognizer(longPressGesture)
        cancelButtonOut.isHidden = true
        cancelButtonOut.layer.cornerRadius = 10
    }
    
    @objc func photoOptions(){
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func uploadPicPressed(_ sender: UIButton) {
        guard let displayName = Auth.auth().currentUser?.displayName  else {
            showAlert(title: "Incomplete profile", message: "Please create a user profile first")
            return
        }
        guard let itemName = nameTextfield.text,
            !itemName.isEmpty,
            let details = detailTextView.text,
            !details.isEmpty,
            let selectedImage = selectedImage
            else {
                showAlert(title: "Missing fields", message: "please enter the item name/detail/photo")
                return
        }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: uploadingImage.bounds)
        dbService.createItem(itemName: itemName, details: details, displayName: displayName) { [weak self] (result) in
          switch result {
          case.failure(let error):
            DispatchQueue.main.async {
              self?.showAlert(title: "Error creating item", message: "Sorry something went wrong: \(error.localizedDescription)")
            }
          case .success(let documentId):
            self?.uploadPhoto(photo: resizedImage, documentId: documentId)
            self?.showAlert(title: nil, message: "Successfully listed item! 🥳")
          }
        }
        
        // feedviewcontroller is not coming from storyboard, does not have outlets
        // but in the case that i'm going to this feedviewcontroller, which does have outlets, the app will crash because this instance of the feedviewcontroller is done programmatically and not using an instance of viewcontroller from storyboard
        //let feedView = FeedViewController()
        
        tabBarController?.selectedIndex = 0
    }
    private func uploadPhoto(photo: UIImage, documentId: String) {
        storageService.uploadPhoto(itemId: documentId, image: photo) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                self?.updateItemImageURL(url, documentId: documentId)
            }
        }
    }
    
    private func updateItemImageURL(_ url: URL, documentId: String) {      Firestore.firestore().collection(DatabaseService.itemsCollection).document(documentId).updateData(["imageURL" : url.absoluteString]) { [weak self] (error) in
        if let error = error {
            DispatchQueue.main.async {
                self?.showAlert(title: "Fail to update item", message: "\(error.localizedDescription)")
            }
        } else {
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        }
    }
    
    @IBAction func cancelPicture(_ sender: UIButton) {
        uploadingImage.image = UIImage(named: "plus")
        cancelButtonOut.isHidden = true
    }
}


extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not attain original image")
        }
        selectedImage = image
        dismiss(animated: true)
    }
}
