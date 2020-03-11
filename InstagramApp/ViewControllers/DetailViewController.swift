//
//  DetailViewController.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var selectedPic: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var picNameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var datePosted: UILabel!
    
    public var post: Pix
    
    init?(coder: NSCoder, _ post: Pix) {
      self.post = post
    super.init(coder: coder)
    }
     
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = post.postedBy
        picNameLabel.text = post.itemName
        detailsLabel.text = post.details
        selectedPic.kf.setImage(with: URL(string: post.imageURL))
        datePosted.text = "\(post.listedDate)"
        print(datePosted)

    }
    
}
