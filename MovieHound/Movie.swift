//
//  Movie.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/2/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import Foundation

public struct Movie {
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
        Movie.getMovieData{(succes, object) in
            print(object ?? "problem with movie Data")
        }
    }
}
