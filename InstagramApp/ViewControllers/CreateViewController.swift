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
    
    @IBOutlet weak var cancelButtonOut: UIButton!
    

    private lazy var imagePickerController: UIImagePickerController = {
      let picker = UIImagePickerController()
      picker.delegate = self // confomrm to UIImagePickerContorllerDelegate and UINavigationControllerDelegate
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
        
        // feedviewcontroller is not coming from storyboard, does not have outlets
        // but in the case that i'm going to this feedviewcontroller, which does have outlets, the app will crash because this instance of the feedviewcontroller is done programmatically and not using an instance of viewcontroller from storyboard
        //let feedView = FeedViewController()
        
        dbService.createItem(itemName: itemName, details: details, displayName: displayName) { [weak self] (result) in
            switch result{
            case .failure(let error):
                self?.showAlert(title: "Failed upload", message: "error uploading item: \(error.localizedDescription)")
                print("fail")
            case .success:
                self?.showAlert(title: nil, message: "Successfully listed item! 🥳")
                print("pass")
            }
        }
        tabBarController?.selectedIndex = 0
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
