//
//  ArticleListViewModel.swift
//  Artilces
//
//  Created by Agam Mahajan on 28/02/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//

import Foundation
import CoreData

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
		self.saveInCoreDataWith(array: articles)
//		for i in 0...(count - 1) {
//			let article  = ArticleModel.init(data: articles[i] )
//			articleDataSource.append(article)
//		}
		delegate?.dataSourceFethced()
	}


	// Core data helpers

	private func createPhotoEntityFrom(dictionary: [AnyHashable: Any]) -> NSManagedObject? {
		let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
		if let articleEntity = NSEntityDescription.insertNewObject(forEntityName: "Articles", into: context) as? Articles {
			articleEntity.title = dictionary["title"] as? String
			articleEntity.articleDescription = dictionary["description"] as? String
			articleEntity.imageUrl = dictionary["urlToImage"] as? String
			articleEntity.link = dictionary["url"] as? String
			return articleEntity
		}
		return nil
	}

	private func saveInCoreDataWith(array: [[AnyHashable: Any]]) {
		_ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
		do {
			try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
		} catch let error {
			print(error)
		}
	}

	var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Articles.self))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		// frc.delegate = self
		return frc
	}()

}
