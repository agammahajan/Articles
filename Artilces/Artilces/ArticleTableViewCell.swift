//
//  ArticleTableViewCell.swift
//  Artilces
//
//  Created by Agam Mahajan on 28/02/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//

import UIKit

protocol ArticleListDelegate: class {
	func clickOnArticleLink(_ link: String)
}

class ArticleTableViewCell: UITableViewCell {

	weak var delegate: ArticleListDelegate?

	@IBOutlet weak var articleImageView: UIImageView!
	@IBOutlet weak var articleTitle: UILabel!
	@IBOutlet weak var articleDescription: UILabel!
	@IBOutlet weak var articleLinkButton: UIButton!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func populateData(data: ArticleModel) {
		articleTitle.text = data.title
		articleDescription.text = data.description
		articleLinkButton.titleLabel?.text = data.articleLink
		articleImageView.setImageWithUrl(urlString: data.imageUrl as NSString, placeholderImage: nil)
	}
	@IBAction func tapOnLink(_ sender: Any) {
		guard let text = articleLinkButton.titleLabel?.text as? String else {return}
		delegate?.clickOnArticleLink(text)
	}
}
