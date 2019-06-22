//
//  DetailViewController.swift
//  Meme 1.0
//
//  Created by Azza on 5/4/19.
//  Copyright © 2019 Azza. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var memeIndex:  Int!
    @IBOutlet weak var memeImageView: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[memeIndex]
        memeImageView.image = meme.memedImage
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}
