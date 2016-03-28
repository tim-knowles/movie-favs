//
//  IMDB.swift
//  Movie-Favs
//
//  Created by Tim Knowles on 21/03/2016.
//  Copyright © 2016 Tim Knowles. All rights reserved.
//

import Foundation
import Alamofire

class IMDB {

//--------------------------------------------------------------------------------------------------
// Lookup - Uses Alamofire to search IMDB using OMDB API
//--------------------------------------------------------------------------------------------------
    func lookup(searchType : String, searchCriteria : String, completion:(NSDictionary!) -> ())  {
        Alamofire.request(
            .GET,
            "http://www.omdbapi.com/?",
            parameters: [searchType : searchCriteria, "plot":"short", "r" : "json", "type" : "movie"],
            encoding: .URL)
            .validate()
            .responseJSON {
                (response) -> Void in
                guard response.result.isSuccess else {
                    completion(nil )
                    return
                }

                if let value = response.result.value  {
                     completion(value as! NSDictionary )
                }else {
                    completion(nil)
                    return
                }
        }
    }
//--------------------------------------------------------------------------------------------------
    
} // END IMDB CLASS