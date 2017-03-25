//
//  APIManager.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/7/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import Foundation


class APIManager {
    static func makeNetworkRequest<T:Parsable>(urlString:String, completion: @escaping (([T])->Void)){
        makeRawNetworkRequest(urlString: urlString) { (data) in
            let result = T.parseJSON(data: data)
            completion(result)
        }
    }

    static func makeRawNetworkRequest(urlString: String, completion: @escaping ((Data) -> Void)) {
        guard let URL = URL(string: urlString) else {
            print("problem with URL")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: URL){ (data, _, error) in
            guard data != nil else {
                print("\(error?.localizedDescription)")
                return
            }
            
            completion(data!)
        }
        task.resume()
    }
}
