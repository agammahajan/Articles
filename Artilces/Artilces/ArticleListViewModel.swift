//
//  ArticleListViewModel.swift
//  Artilces
//
//  Created by Agam Mahajan on 28/02/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//

import Foundation

protocol ArticleListViewModelDelegate: class {
	func dataSourceFethced()
}

class ArticleListViewModel {

	weak var viewController: ArticleListTableViewController?
	weak var delegate: ArticleListViewModelDelegate?

	var articleDataSource: [ArticleModel] = []

	class func initWith(_ viewController: ArticleListTableViewController) -> ArticleListViewModel {
		let viewModel = ArticleListViewModel()
		viewModel.viewController = viewController
		return viewModel
	}

	func fetchArticles() {
		let url = "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=a8fabd9ff4234c82aad08eaaa4ea17a0"
		NetworkManager.sharedInstance.get(urlString: url, success: { response, responseDict in
			if let data = responseDict, let status:String = data["status"] as? String, status == "ok" {
				self.traverseArticleData(data: data)
			}
		}) { response, responseDict, error in

		}
	}

	func traverseArticleData(data: [AnyHashable: Any]) {
		guard let count = data["totalResults"] as? Int, let articles = data["articles"] as? [[AnyHashable: Any]]  else {return}
		for i in 0...(count - 1) {
			let article  = ArticleModel.init(data: articles[i] )
			articleDataSource.append(article)
		}
		delegate?.dataSourceFethced()
	}
}
