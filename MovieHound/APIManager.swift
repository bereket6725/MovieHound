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
    static func makeNetworkRequest<P: Parsable>(urlString:String, completion: @escaping ((Result<[P]>) -> Void)) {
        makeRawNetworkRequest(urlString: urlString) { result in
            switch result {
            case .success(let data):
                let models = P.parseJSON(data: data)
                completion(Result.success(models))
            case .error(let error):
                completion(Result.error(error))
            }
        }
    }
    
    static func makeNYTNetworkRequest(forQuery query: String, completion: @escaping (Result<URL>) -> Void) {
        let urlString = "\(Constants.APIURLS.nytAPIURL)&query=\(query.ped_encodeURI())"
        makeRawNetworkRequest(urlString: urlString, completion: { result in
            switch result {
            case .success(let data):
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
            case .error(let error):
                completion(Result.error(error))
            }
        })
    }

    static func makeRawNetworkRequest(urlString: String, completion: @escaping ((Result<Data>) -> Void)) {
        guard let URL = URL(string: urlString) else {
            completion(Result.error("problem with URL"))
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: URL){ (data, _, error) in
            guard let data = data else {
                completion(Result.error("\(error?.localizedDescription)"))
                return
            }
            completion(Result.success(data))
        }
        task.resume()
    }
}
