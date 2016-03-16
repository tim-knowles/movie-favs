//
//  MovieCell.swift
//  Movie-Favs
//
//  Created by Tim Knowles on 15/03/2016.
//  Copyright © 2016 Tim Knowles. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieTitle : UILabel!
    @IBOutlet weak var movieImage : UIImageView!
    @IBOutlet weak var movieDetailBtn : UIButton!
    @IBOutlet weak var movieRating: Rating!
    
    //Possible upgrade to include the move rating system
    // @IBOutlet weak var movieRating : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(movie : Movie) {
        movieTitle.text = movie.movieTitle
        
        //movieImage.image = movie.getMovieImg()
        
        if let img = movie.movieImage {
            movieImage.image = UIImage(data: img)!
        }
        
        movieRating.readOnly = true
        movieRating.rating = Int(movie.movieRating!)
        
        
    }
    
    


}
