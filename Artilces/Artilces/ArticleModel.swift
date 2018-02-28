//
//  ArticleModel.swift
//  Artilces
//
//  Created by Agam Mahajan on 28/02/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//

import Foundation

class ArticleModel {
	var title: String = ""
	var description: String = ""
	var imageUrl: String = ""
	var articleLink: String = ""

	init(data: [AnyHashable: Any]) {
		title = data["title"] as? String ?? ""
		description = data["description"] as? String ?? ""
		imageUrl = data["urlToImage"] as? String ?? ""
		articleLink = data["url"] as? String ?? ""
	}
}
