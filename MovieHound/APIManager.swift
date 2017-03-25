//
//  APIManager.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/7/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import Foundation
import PercentEncoder
import SwiftyJSON

enum Result<T> {
    case success(T)
    case error(String)
}

class APIManager {
    // TODO: Make this return a Result instead of a [T]
    static func makeNetworkRequest<T:Parsable>(urlString:String, completion: @escaping (([T])->Void)){
        makeRawNetworkRequest(urlString: urlString) { (data) in
            let result = T.parseJSON(data: data)
            completion(result)
        }
    }
    
    static func makeNYTNetworkRequest(forQuery query: String, completion: @escaping (Result<URL>) -> Void) {
        let urlString = "\(Constants.APIURLS.nytAPIURL)&query=\(query.ped_encodeURI())"
        makeRawNetworkRequest(urlString: urlString, completion: { (data) in
            let json = JSON(data: data)
            let results = json["results"].arrayValue
            
            guard let firstResult = results.first,
                let link = firstResult["link"].dictionaryValue["url"]?.stringValue else {
                completion(Result.error("Couldn't load results"))
                return
            }
            guard let url = URL(string: link) else {
                completion(Result.error("Couldn't parse link to NYT"))
                return
            }
            completion(Result.success(url))
        })
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
