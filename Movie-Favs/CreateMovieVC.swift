//
//  CreateMovieVC.swift
//  Movie-Favs
//
//  Created by Tim Knowles on 15/03/2016.
//  Copyright © 2016 Tim Knowles. All rights reserved.
//

import UIKit
import CoreData


class CreateMovieVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var movieTitle : UITextField!
    @IBOutlet weak var movieDesc : UITextField!
    @IBOutlet weak var movieURL : UITextField!
    @IBOutlet weak var movieCast : UITextField!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieRating: Rating!
    
    @IBOutlet var innerView: UIView!
    
    
    var imagePicker: UIImagePickerController!
    
    enum CreateError: String{
        case Title = "Title is missing"
        
        case Description = "Description is missing"
        case Cast = "Cast is missing"
        case URL = "URL is missing"
        case Rating = "Rating was not set"
        case Image = "No image selected"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        movieImg.layer.cornerRadius = 4.0
        movieImg.clipsToBounds = true
        
        //Set background on the UIView object
        innerView.layer.contents = UIImage(named:"background")!.CGImage
    }


    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        movieImg.image = image
    }
    
    
    @IBAction func addImagePressed(sender: UIButton) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func createMoviePressed(sender : UIButton) {


        
        let bulletPoint = "\u{2022} "
        
        var err = [CreateError]()
        
        if let title = movieTitle.text where title == "" {
            err.append(CreateError.Title)
        }
        
        if let desc = movieDesc.text where desc == "" {
            err.append(CreateError.Description)
        }
        
        if let cast = movieCast.text where cast == "" {
            err.append(CreateError.Cast)
        }
        
        if let URL = movieURL.text where URL == "" {
            err.append(CreateError.URL)
        }
        

        //let size = CGSize(width: 0, height: 0)
        if movieImg.image?.size.width < 1 {
            err.append(CreateError.Image)
         }

        
        
        if err.count > 0 {
            var errString = ""
            
            for var x = 0; x < err.count; x++ {
                errString += bulletPoint + err[x].rawValue + "\n"
            }
            

            showError("Oops! We're Missing Things...", errMessage: errString)

            
            
        } else if err.count == 0 {
            print("Calling save movie from CreateMovieVC")
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = app.managedObjectContext
            let entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: context)!
            var movie : Movie!
            movie = Movie(entity: entity, insertIntoManagedObjectContext: context)
            
            movie.movieTitle = movieTitle.text
            movie.movieDesc = movieDesc.text
            movie.movieCast = movieCast.text
            movie.movieLink = movieURL.text
            movie.setMovieImg(movieImg.image!)
            //Movie rating could be 0 stars and the view defaults to 0 so whatever the case just save the rating
            movie.movieRating = Int(movieRating.rating)
            
            movie.saveMovie(movie)
            self.navigationController?.popViewControllerAnimated(true)
        }
        

        
        
    }
    
    func showError(errTitle: String, errMessage : String) {
        let alertController = UIAlertController(title: errTitle, message: errMessage, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
        
        let messageText = NSMutableAttributedString(
            string: errMessage,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(13.0)
            ]
        )
        
        alertController.setValue(messageText, forKey: "attributedMessage")
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }



}
