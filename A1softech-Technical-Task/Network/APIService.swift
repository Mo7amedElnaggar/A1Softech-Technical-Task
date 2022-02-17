//
//  APIService.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/14/22.
//

import Foundation
import Alamofire

class APIService {
    // Singlton
    static let shared = APIService()
    
    func loadResponse<T: Decodable>(url: String, method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      headers: HTTPHeaders? = nil,
                      completion: @escaping ((T?, Error?) -> Void)) {
        print("Calling: ", url)
        DispatchQueue.global(qos: .utility).async {
            AF.request(url, method: method, parameters: parameters, headers: headers)
                .validate(statusCode: 200...300)
                .responseJSON { (response) in
                    guard let data = response.data else { return }

                    switch response.result {
                    case .failure(let err):
                        print(err.localizedDescription)
                    case .success(let value):
                        print(value)
                        
                        do {
                            let result = try JSONDecoder().decode(T.self, from: data)
                            completion(result, nil)
                        } catch {
                            completion(nil, error)
                        }
                    }
                }
        }
    }
}
