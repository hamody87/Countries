//
//  RequestJSON.swift
//  Countries
//
//  Created by Muhammad Jbara on 22/04/2021.
//

import UIKit

final class RequestJSON {
    
    // MARK: - Declare Basic Variables
    
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Public Methods
    
    func request(withUrl url: String, successBlock success: @escaping ((Data?) -> ()), failureBlock failure: @escaping (() -> ())) {
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else {
                return
            }
            self.dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in defer {
                self?.dataTask = nil
            }
            if let _ = error {
                failure()
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    success(data)
                }
            }
          }
          dataTask?.resume()
        }
    }

}
