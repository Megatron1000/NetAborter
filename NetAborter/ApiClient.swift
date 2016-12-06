//
//  ApiClient.swift
//  NetAborter
//
//  Created by Mark Bridges on 24/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import Foundation


class ApiClient {

    enum ApiClientResult {
        case success(data: Data?)
        case failure(error: Error)
    }

    
    let session: NetworkSession

    required init(session: NetworkSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }


    func makeNetworkRequest(with url: URL, completion: @escaping ((ApiClientResult) -> Void)) {

        session.startDataTask(with: url, completionHandler: { (data, _, error) -> Void in

            if let error = error {
                completion(.failure(error: error))
                return
            }

            completion(.success(data: data))
        })
    }
}


// MARK: NetworkSession protocol

protocol NetworkSession {
    func startDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
}


extension URLSession: NetworkSession {

    func startDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let dataTask = self.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
}
