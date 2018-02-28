//
//  ArticleListTableViewController.swift
//  Artilces
//
//  Created by Agam Mahajan on 28/02/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//

import UIKit

class ArticleListTableViewController: UITableViewController, ArticleListDelegate {

	var articleViewModel: ArticleListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func setupViews() {
		self.tableView.estimatedRowHeight = 250
		self.tableView.rowHeight = UITableViewAutomaticDimension
		articleViewModel = ArticleListViewModel.initWith(self)
		articleViewModel.fetchArticles()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		if let count = articleViewModel.fetchedhResultController.sections?.first?.numberOfObjects {
			return count
		}
		return 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ArticleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
		cell.delegate = self
		if let article = articleViewModel.fetchedhResultController.object(at: indexPath) as? Articles {
			cell.populateData(data: article)
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
		if let article = articleViewModel.fetchedhResultController.object(at: indexPath) as? Articles, let link = article.link {
			clickOnArticleLink(link)
		}

	}

	// MARK: - Article Table View Cell delegates

	func clickOnArticleLink(_ link: String) {
		UIApplication.shared.open(URL(string : link)!, options: [:], completionHandler: nil)
	}

}
