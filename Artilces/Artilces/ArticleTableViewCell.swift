//
//  ArticleTableViewCell.swift
//  Artilces
//
//  Created by Agam Mahajan on 28/02/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

	@IBOutlet weak var articleImageView: UIImageView!
	@IBOutlet weak var articleTitle: UILabel!
	@IBOutlet weak var articleDescription: UILabel!
	@IBOutlet weak var articleLinkButton: UIButton!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
