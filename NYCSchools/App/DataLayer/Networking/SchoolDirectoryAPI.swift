//
//  SchoolDirectoryAPI.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-17.
//

import Foundation
import Alamofire

typealias SchoolListAPIResponse = (Swift.Result<[School]?, DataError>) -> Void

protocol SchoolAPILogic {
    func getSchools(completion: @escaping SchoolListAPIResponse)
}

class SchoolAPI: SchoolAPILogic {
    private struct Constants {
        static let schoolListURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$$app_token=L1KwLSwm1yz1N7aWqFCF4dLmM"
    }
    
    // have to get @escapte the closure because there is async call inside the closure
    func getSchools(completion: @escaping SchoolListAPIResponse) {
        // 1.Using Apple Standard Services
        // retrieveSchoolsUsingStdServices()
        
        // 2.Using Alamofire Library on Cocoapods
        AF.request(Constants.schoolListURL)
            .validate() // ensure the status code back gets value of 200..299
            .responseDecodable(of: [School].self) { response in //get it decoded into School objects
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let schools):
                    completion(.success(schools))
                }
            }
    }
    
    private func retrieveSchoolsUsingStdServices() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "data.cityofnewyork.us"
        urlComponents.path = "/resource/s3k6-pzi2.json"
        urlComponents.queryItems = [URLQueryItem(name: "$$app_token", value: "L1KwLSwm1yz1N7aWqFCF4dLmM")]
        
        // another way to get url
        // URL(string: Constants.schoolListURL)
        
        if let url = urlComponents.url {
            let urlSession = URLSession(configuration: .default)
            
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    print("error occured \(String(describing: error?.localizedDescription))")
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let schools = try decoder.decode([School].self, from: data)
                        print("schools \(schools.count)")
                    } catch let error {
                        print("error during parsing JSON \(error)")
                    }
                }
                    
            }
            task.resume()
        }
    }
    
}
