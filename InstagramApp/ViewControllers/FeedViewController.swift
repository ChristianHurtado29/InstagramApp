//
//  FeedViewController.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let pix = [Pix]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PixCell.self, forCellWithReuseIdentifier: "PixCell")
    }
    

}

extension FeedViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pixCell", for: indexPath)
     //   let selPix = pix[indexPath.row]
        
        return cell
    }
    
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout{
    
}
