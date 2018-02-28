//
//  ArticleListViewModel.swift
//  Artilces
//
//  Created by Agam Mahajan on 28/02/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//

import Foundation

protocol ArticleListDelegate: class {
	func clickOnArticleLink(_ link: String)
}

class ArticleListViewModel {

	weak var viewController: ArticleListTableViewController?
	weak var delegate: ArticleListDelegate?

	class func initWith(_ viewController: ArticleListTableViewController) -> ArticleListViewModel {
		let viewModel = ArticleListViewModel()
		viewModel.viewController = viewController
		return viewModel
	}
}
