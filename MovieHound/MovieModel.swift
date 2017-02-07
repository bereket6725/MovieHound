//
//  MovieModel.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/7/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import Foundation


struct MovieModel {

    typealias JSONStandard = [String:AnyObject]
    public struct Movie: Parsable {
        static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
        public var title: String!
        public var imagePath: String!
        public var description: String!

        public init (title: String, imagePath: String, description: String){
            self.title = title
            self.imagePath = imagePath
            self.description = description
        }
        static func parseJSON(data: Data) -> [MovieModel.Movie] {
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! JSONStandard else {
                print("could not serialize JSON")
                return []
            }
            var movieArray = [Movie]()
            if let movieResults = json["results"] as? [Dictionary<String,AnyObject>]{
                for movie in movieResults{
                    let title = movie["original_title"] as! String
                    let description = movie["overview"] as! String
                    guard let posterImage = movie["poster_path"] as? String else {continue}
                    let movieObj = Movie(title: title, imagePath: posterImage, description: description)
                    movieArray.append(movieObj)
                }
                return movieArray
            }else{
                return []
            }

        }

    }
}
