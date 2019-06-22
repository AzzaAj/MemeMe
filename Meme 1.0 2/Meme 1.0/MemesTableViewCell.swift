//
//  MemesTableViewCell.swift
//  Meme 1.0
//
//  Created by Azza on 5/3/19.
//  Copyright © 2019 Azza. All rights reserved.
//

import UIKit

class MemesTableViewCell: UITableViewCell {
    @IBOutlet weak var sentMemeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
