//
//  DetailVC.swift
//  Movie-Favs
//
//  Created by Tim Knowles on 15/03/2016.
//  Copyright © 2016 Tim Knowles. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var movieTitle : UILabel!
    @IBOutlet weak var movieDescription : UILabel!
    @IBOutlet weak var movieImage : UIImageView!
    @IBOutlet weak var movieCast : UILabel!
    @IBOutlet weak var movieURL : UILabel!
    @IBOutlet weak var movieRating : Rating!
    
    var movie : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movie.movieTitle != nil {
            presentMovieDetail()
        }
    }
    
    override func awakeFromNib() {

    }

    func presentMovieDetail() {
        if let title = movie!.movieTitle {
            print("Title is \(title)")
            //self.movieTitle.text = "test"
            movieTitle.text = title
        }
    }



}
