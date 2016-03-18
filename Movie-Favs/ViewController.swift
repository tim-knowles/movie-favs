//
//  ViewController.swift
//  Movie-Favs
//
//  Created by Tim Knowles on 15/03/2016.
//  Copyright © 2016 Tim Knowles. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView : UITableView!
    var movieObject : Movie!
    var moviesList = [Movie]()
    
    @IBOutlet var innerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //movieObject = Movie()
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        movieObject = Movie(entity: NSEntityDescription.entityForName("Movie", inManagedObjectContext: context)!, insertIntoManagedObjectContext: .None)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set background on the UIView object
        innerView.layer.contents = UIImage(named:"background")!.CGImage
        tableView.backgroundColor = UIColor(white: 1, alpha: 0)
        //tableView.layer.backgroundColor = UIColor(white: 1, alpha: 0.5)
        //tableView.layer.contents = UIImage(named:"background")!.CGImage
    }

    
    override func viewDidAppear(animated: Bool) {
        moviesList = movieObject.fetchMovieList()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as? MovieCell {
            let movie = moviesList[indexPath.row]
            cell.configureCell(movie)
            
            return cell
        }else{
            return MovieCell()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }


    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailSegue") {
            
            var indexPath : Int!
            
            
            //get the cell row index by locating it from the button parent
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? MovieCell {
                        indexPath = tableView.indexPathForCell(cell)?.row
                    }
                }
            }
            
            //get a reference to the destination view controller
            let destinationVC = segue.destinationViewController as! DetailVC

            if let idx = indexPath {
                destinationVC.movie = moviesList[idx]
            }


        }
        
    }
}

