//
//  Movie.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/2/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import UIKit

//MARK: TO DO
//1. Learn AMC Locator API
//2. Drop places on MapView
//3. Find a Movie Review API (Maybe NYTimes??)
//4. Purchase AMC Ticket Using BraintTree API
//5. Switch to AMC Now Playing API


public struct Movie {
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w500"

    
    public var title: String!
    public var imagePath: String!
    public var description: String!

    public init (title: String, imagePath: String, description: String){
        self.title = title
        self.imagePath = imagePath
        self.description = description
    }

    private static func getMovieData(with completion: @escaping (_ success: Bool, _ object: AnyObject?)->()){
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=e270b14e907deaf2179a07bfd97bc94a")!)
        session.dataTask(with: request) {(data:Data?,response: URLResponse?, error: Error?) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject?)
                }
                else{
                    completion(false, json as AnyObject?)
                }
            }
            }.resume()
    }

    public static func nowPLaying (with completion: @escaping(_ success: Bool, _ movies: [Movie]?)->()){
        Movie.getMovieData{(success, object) in
            //print(object ?? "problem with movie Data")
            //need "original_title", "overview" and "poster path" values from JSON

            if success{
                var movieArray = [Movie]()
                if let movieResults = object?["results"] as? [Dictionary<String,AnyObject>]{
                    for movie in movieResults{
                        let title = movie["original_title"] as! String
                        let description = movie["overview"] as! String
                        guard let posterImage = movie["poster_path"] as? String else {continue}
                        let movieObj = Movie(title: title, imagePath: posterImage, description: description)
                        movieArray.append(movieObj)
                    }
                    completion(true, movieArray)
                }else{
                    completion(false, nil)
                }
            }
        }
    }

    private static func getDocumentsDirectory() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documents:String = paths.first else {return nil}

        return documents
    }

    private static func checkForImageData (withMovieObject movie: Movie)->String?{
        if let documents = getDocumentsDirectory(){
            let movieImagePath = documents + "/\(movie.title!)"
            let escapedImagePath = movieImagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

            if FileManager.default.fileExists(atPath: escapedImagePath!){
                return escapedImagePath
            }
        }
        return nil
    }

    public static func getImage (forCell cell: AnyObject, withMovieObject movie: Movie){
        if let imagePath = checkForImageData(withMovieObject: movie) { // image is already downloaded
            if let imageData = FileManager.default.contents(atPath: imagePath) {
                if cell is UITableViewCell{
                    let tableViewCell = cell as! UITableViewCell
                    tableViewCell.imageView?.image = UIImage(data: imageData)
                    tableViewCell.setNeedsLayout()
                }else{
                    //Add CollectionView Cell implementation
                }
            }
        }
        else{//have to download image and save it to disk
            let imagePath = Movie.imageBaseURL + movie.imagePath
            let imageURL = URL(string: imagePath)

            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
                do {
                    let data = try Data(contentsOf: imageURL!)
                    let documents = getDocumentsDirectory()
                    let imageFilePathString = documents! + "/\(movie.title)"
                    let escapedImagePath = imageFilePathString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    if FileManager.default.createFile(atPath: escapedImagePath, contents: data, attributes: nil){
                        print("imageSaved")
                    }

                }
                catch {
                    print("no image at specified location")
                }
            }
        }
    }
}
