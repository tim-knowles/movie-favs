//
//  Movie.swift
//  Movie-Favs
//
//  Created by Tim Knowles on 15/03/2016.
//  Copyright © 2016 Tim Knowles. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Movie: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    

    
    func setMovieImg(img : UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.movieImage = data
    }
    
    func getMovieImg() -> UIImage {
        let img = UIImage(data: self.movieImage!)!
        return img
    }
    
    func fetchMovieList() -> [Movie] {
        var movieList = [Movie]()
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
        let context = app!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            movieList = results as! [Movie]
        } catch let err as NSError {
                print(err.debugDescription)
        
        }
        
        return movieList
    }
    
    
    func saveMovie(movie : Movie) {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        //let entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: context)!
        //let movieObject = Movie(entity: entity, insertIntoManagedObjectContext: context)
        
        context.insertObject(movie)
        
        do {
            try context.save()
        } catch {
            print("Could not save movie")
        }
    }
}
