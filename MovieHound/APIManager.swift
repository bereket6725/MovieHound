//
//  APIManager.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/4/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import Foundation


class APIManager {
    static func makeNetworkRequest<T:Parsable>(_ success: Bool, _ urlString: String,completion: @escaping(([T])->Void)){
        guard let url = URL(string: urlString) else{
            print("problem with URL")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url){(data, response, error) in
            guard let data = data  else {
                print("\(error?.localizedDescription)")
                return
            }
        let result = T.parseJSON(data: data)
        completion(result)
        }
        task.resume()
    }
}
