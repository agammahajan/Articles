//
//  ArticleListViewModel.swift
//  Artilces
//
//  Created by Agam Mahajan on 28/02/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//

import Foundation
import CoreData

class ArticleListViewModel: NSObject {

	weak var viewController: ArticleListTableViewController?
	
	class func initWith(_ viewController: ArticleListTableViewController) -> ArticleListViewModel {
		let viewModel = ArticleListViewModel()
		viewModel.viewController = viewController
		return viewModel
	}

	func fetchArticles() {
		do {
			try self.fetchedhResultController.performFetch()
			print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
		} catch let error  {
			print("ERROR: \(error)")
		}

		let url = "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=a8fabd9ff4234c82aad08eaaa4ea17a0"
		NetworkManager.sharedInstance.get(urlString: url, success: { response, responseDict in
			if let data = responseDict, let status:String = data["status"] as? String, status == "ok" {
				self.clearData()
				self.traverseArticleData(data: data)
			} else {
				self.viewController?.refreshControl?.endRefreshing()
			}
		}) { response, responseDict, error in
			self.viewController?.refreshControl?.endRefreshing()
		}
	}

	func traverseArticleData(data: [AnyHashable: Any]) {
		guard let articles = data["articles"] as? [[AnyHashable: Any]]  else {return}
		self.saveInCoreDataWith(array: articles)
		self.viewController?.refreshControl?.endRefreshing()
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
		fetchRequest.fetchBatchSize = 5
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		return frc
	}()

	private func clearData() {
		do {
			let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Articles")
			do {
				let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
				_ = objects.map{$0.map{context.delete($0)}}
				CoreDataStack.sharedInstance.saveContext()
			} catch let error {
				print("ERROR DELETING : \(error)")
			}
		}
	}

}
