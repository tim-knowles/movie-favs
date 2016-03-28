//
//  CreateMovieVC.swift
//  Movie-Favs
//
//  Created by Tim Knowles on 15/03/2016.
//  Copyright © 2016 Tim Knowles. All rights reserved.
//

import UIKit
import CoreData


class CreateMovieVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieTitle : UITextField!
    @IBOutlet weak var movieDesc : UITextField!
    @IBOutlet weak var movieURL : UITextField!
    @IBOutlet weak var movieCast : UITextField!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieRating: Rating!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var titleStack: UIStackView!
    @IBOutlet weak var movieStack: UIStackView!
    
    var movieChoices : [[String : String]]!
    var selectedMovie : NSDictionary!
    var movieView = UIView()
    var tableView = UITableView()
    //var imdb : IMDB?
    var imagePicker: UIImagePickerController!
    
    enum CreateError: String{
        case Title = "Title is missing"
        case Description = "Description is missing"
        case Cast = "Cast is missing"
        case URL = "URL is missing"
        case Rating = "Rating was not set"
        case Image = "No image selected"
    }
    
    enum searchType : String {
        case Search = "s"
        case Title = "t"
        case ID = "i"
    }
    
//--------------------------------------------------------------------------------------------------
// View Loaded
//--------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        movieImg.layer.cornerRadius = 4.0
        movieImg.clipsToBounds = true
        
        //Set background on the UIView object
        innerView.layer.contents = UIImage(named:"background")!.CGImage
        
        tableView.rowHeight = 18
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
//--------------------------------------------------------------------------------------------------
    
    
//--------------------------------------------------------------------------------------------------
// Search Movies - looks up movies on OMDB using the users text
//--------------------------------------------------------------------------------------------------
    func searchForMovies(str : String) {
        let params = ["type"  : searchType.Search.rawValue, "criteria" : str]
        
        movieLookup(params) {
            response in
            if response["Response"] as? String == "True" {
                let list = response.objectForKey("Search")
                
                self.movieChoices = list! as! [[String : String]]
                self.showChoiceList()
            }else{
                self.movieView.removeFromSuperview()
            }
        }
    }
//--------------------------------------------------------------------------------------------------

    
//--------------------------------------------------------------------------------------------------
// Get Selected Movie - looks up movie on OMDB using the ID
//--------------------------------------------------------------------------------------------------
    func getSelectedMovie(ID : String) {
        let params = ["type"  : searchType.ID.rawValue, "criteria" : ID]
        
        movieLookup(params) {
            response in
            self.movieTitle.text = response["Title"] as? String
            self.movieDesc.text = response["Plot"] as? String
            self.movieCast.text = response["Actors"] as? String
            self.movieImg.downloadedFrom(link: (response["Poster"] as? String)!, contentMode: .ScaleAspectFill)
            self.movieURL.text = "http://www.imdb.com/title/\(ID)"
            
            //Clean up by removing the selector
            self.movieChoices = []
            self.tableView.reloadData()
            self.movieView.removeFromSuperview()
        }
    }
//--------------------------------------------------------------------------------------------------
    
    
//--------------------------------------------------------------------------------------------------
// Movie Lookup - Generic lookup function to operate the two different types of search
//--------------------------------------------------------------------------------------------------
    
    func movieLookup(params : [String:String], completion : ((NSDictionary) -> Void)?) {
        let imdb = IMDB()
        
        imdb.lookup(params["type"]!,searchCriteria: params["criteria"]!) {
            responseObject in
            if responseObject.count > 0 {
                completion!(responseObject)
            }

            return
        }
    }
//--------------------------------------------------------------------------------------------------
 
    
//--------------------------------------------------------------------------------------------------
// Dynamic Table Functions
//--------------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieChoices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let curMovie = movieChoices[indexPath.row]
        
        cell.textLabel?.text = curMovie["Title"]
        
        return cell
    }
    
    func tableView(let tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedTitle = movieChoices[indexPath.row]["imdbID"]
        
        getSelectedMovie(selectedTitle!)
    }
//--------------------------------------------------------------------------------------------------

    
//--------------------------------------------------------------------------------------------------
// Show Choice List - dynamically creates a stackview with a view
//--------------------------------------------------------------------------------------------------
    func showChoiceList(){
        //Add a the movie view and set it's constraints
        titleStack.addArrangedSubview(movieView)
        
        let horizonalContraintsView = NSLayoutConstraint(item: movieView, attribute:
            .Leading, relatedBy: .Equal, toItem: titleStack,
            attribute: .Leading, multiplier: 1.0, constant: 0)
        
        let horizonal2ContraintsView = NSLayoutConstraint(item: movieView, attribute:
            .Trailing, relatedBy: .Equal, toItem: titleStack,
            attribute: .Trailing, multiplier: 1.0, constant: 0)
        
        let pinTop = NSLayoutConstraint(item: movieView, attribute: .Top, relatedBy: .Equal,
            toItem: titleStack, attribute: .Top, multiplier: 1.0, constant: movieTitle.bounds.height)
        
        let heightConstraint = NSLayoutConstraint(item: movieView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
        
        movieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([horizonalContraintsView, horizonal2ContraintsView, pinTop, heightConstraint])
        
    
        //Add table view and set it's constraints
        movieView.addSubview(tableView)
        
        let horizonalContraints = NSLayoutConstraint(item: tableView, attribute:
            .Leading, relatedBy: .Equal, toItem: movieView,
            attribute: .Leading, multiplier: 1.0, constant: 0)
        
        let horizonal2Contraints = NSLayoutConstraint(item: tableView, attribute:
            .Trailing, relatedBy: .Equal, toItem: movieView,
            attribute: .Trailing, multiplier: 1.0, constant: 0)
        
        let pinTopLabel = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal,
            toItem: movieView, attribute: .Top, multiplier: 1.0, constant: 0)
        
        let pinBotLabel = NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal,
            toItem: movieView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([horizonalContraints, horizonal2Contraints, pinTopLabel,pinBotLabel])
        
        tableView.reloadData()
    }
//--------------------------------------------------------------------------------------------------

    
//--------------------------------------------------------------------------------------------------
// Image Picker
//--------------------------------------------------------------------------------------------------
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        movieImg.image = image
    }
//--------------------------------------------------------------------------------------------------
    
    
//--------------------------------------------------------------------------------------------------
// Show Error - presenets a nicely formatted alert with left aligned text
//--------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------
// BUTTON - Add
//--------------------------------------------------------------------------------------------------
    @IBAction func addImagePressed(sender: UIButton) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
//--------------------------------------------------------------------------------------------------
    
    
//--------------------------------------------------------------------------------------------------
// BUTTON - Create
//--------------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------------
    

//--------------------------------------------------------------------------------------------------
// TEXT FIELD - Movie Title
//--------------------------------------------------------------------------------------------------
    @IBAction func movieTitleChanged(sender: UITextField) {
        if sender.text?.characters.count > 2 {
            searchForMovies(sender.text!)
        }
    }
//--------------------------------------------------------------------------------------------------
    
 

} // END CreateMovieVC CLASS
