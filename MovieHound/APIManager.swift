//
//  APIManager.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/4/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import Foundation


class APIManager {
    static func makeNetworkRequest(with completion: @escaping (_ success: Bool, _ object: AnyObject?)->()){
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
}
