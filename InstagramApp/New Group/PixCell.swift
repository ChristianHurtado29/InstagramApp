//
//  PixCVC.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit

class PixCell: UICollectionViewCell {
    
    @IBOutlet weak var picImageView: UIImageView!
    
    public func configureCell(for pic: Pix) {
        let colorImage = pic.image.withTintColor(UIColor.generateRandomColor(), renderingMode: .alwaysOriginal)
        picImageView.image = colorImage
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

