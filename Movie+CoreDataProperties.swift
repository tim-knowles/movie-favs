//
//  Movie+CoreDataProperties.swift
//  Movie-Favs
//
//  Created by Tim Knowles on 15/03/2016.
//  Copyright © 2016 Tim Knowles. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var movieTitle: String?
    @NSManaged var movieDesc: String?
    @NSManaged var movieLink: String?
    @NSManaged var movieRating: NSNumber?
    @NSManaged var movieImage: NSData?
    @NSManaged var movieCast: NSObject?

}
