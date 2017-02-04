//
//  CacheManager.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/4/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import UIKit 

class CacheManager{
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
                    DispatchQueue.main.async(execute: {
                        if cell is UITableViewCell{
                            let tableViewCell = cell as! UITableViewCell
                            tableViewCell.imageView?.image = UIImage(data: data)
                            tableViewCell.setNeedsLayout()
                        }else{
                            //Add CollectionView Cell implementation
                        }

                    })

                }
                catch {
                    print("no image at specified location")
                }
            }
        }
    }
    
}
