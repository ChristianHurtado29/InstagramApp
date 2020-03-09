//
//  FeedViewController.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
    private var pix = [Pix](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        listener = Firestore.firestore().collection(DatabaseService.itemsCollection).addSnapshotListener({ [weak self] (snapshot, error) in
          if let error = error {
            DispatchQueue.main.async {
              self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
            }
          } else if let snapshot = snapshot {
            let pics = snapshot.documents.map { Pix($0.data()) }
            self?.pix = pics
          }
        })
    }
    

}

extension FeedViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pix.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PixCell", for: indexPath) as? PixCell else{
            fatalError("could not downcast to PixCell")
        }
        let selPix = pix[indexPath.row]
        cell.configureCell(for: selPix)
        cell.backgroundColor = .systemGroupedBackground
        return cell
    }
}


extension FeedViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let maxSize: CGSize = UIScreen.main.bounds.size
      let spacingBetweenItems: CGFloat = 5
      let numberOfItems: CGFloat = 2
      let totalSpacing: CGFloat = (3 * spacingBetweenItems) + (numberOfItems - 1) * spacingBetweenItems
      let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
      let itemHeight: CGFloat = maxSize.height * 0.20
      return  CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
    }
}
