//
//  CacheManager.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/4/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import UIKit 

class CacheManager{

    //creates a path to place in directory where image will be stored
    private static func getDocumentsDirectory() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documents:String = paths.first else {return nil}

        return documents
    }
    //checks if image is downloaded
     private static func checkForImageData (withMovieObject movie: MovieModel)->String?{
        if let documents = getDocumentsDirectory(){
            let movieImagePath = documents + "/\(movie.title!)"
            let escapedImagePath = movieImagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

            if FileManager.default.fileExists(atPath: escapedImagePath!){
                return escapedImagePath
            }
        }
        return nil
    }

    static func getImage (forCell cell: AnyObject, withMovieObject movie: MovieModel){
        if let imagePath = checkForImageData(withMovieObject: movie) { // image is already downloaded
            if let imageData = FileManager.default.contents(atPath: imagePath) {
                if cell is UICollectionViewCell{
                    let collectionViewCell = cell as! MovieCollectionViewCell
                    collectionViewCell.movieImageView?.image = UIImage(data: imageData)
                    collectionViewCell.setNeedsLayout()
                }
            }
        }
        else{//have to download image and save it to disk
            downloadImageAndSaveToDisk(forCell: cell, withMovieObject: movie)
        }
    }

    private static func downloadImageAndSaveToDisk(forCell cell: AnyObject, withMovieObject movie: MovieModel){
        let imagePath = MovieModel.imageBaseURL + movie.imagePath
        let imageURL = URL(string: imagePath)

        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async{
            do {
                let data = try Data(contentsOf: imageURL!)
                if let documents = getDocumentsDirectory(){
                    let imageFilePathString = documents + "/\(movie.title)"
                    let escapedImagePath = imageFilePathString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    if FileManager.default.createFile(atPath: escapedImagePath, contents: data, attributes: nil){
                        print("imageSaved")
                    }
                }
                DispatchQueue.main.async(execute: {
                    if cell is UICollectionViewCell{
                        let collectionViewCell = cell as! MovieCollectionViewCell
                        collectionViewCell.movieImageView?.image = UIImage(data: data)
                        collectionViewCell.setNeedsLayout()
                    }                    })
            }
            catch {
                print("no image at specified location")
            }

    }

    }
}
