//
//  PixCVC.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit
import Kingfisher

class PixCell: UICollectionViewCell {
    
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var postedBy: UILabel!
    
    public func configureCell(for pic: Pix) {
        picImageView.kf.setImage(with: URL(string: pic.imageURL))
        postedBy.text = "By: \(pic.postedBy)"
    }
}

extension UIColor {
    static func generateRandomColor() -> UIColor {
        let redValue = CGFloat.random(in: 0...1)
        let greenValue = CGFloat.random(in: 0...1)
        let blueValue = CGFloat.random(in: 0...1)
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        return randomColor
    }
}

