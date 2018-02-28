//
//  Articles+CoreDataProperties.swift
//  Artilces
//
//  Created by Agam Mahajan on 01/03/18.
//  Copyright © 2018 Agam Mahajan. All rights reserved.
//
//

import Foundation
import CoreData


extension Articles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Articles> {
        return NSFetchRequest<Articles>(entityName: "Articles")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var link: String?
    @NSManaged public var title: String?

}
