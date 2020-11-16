//
//  NetworkService.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 14/11/20.
//

import Foundation
import Alamofire
 
struct NetWorkService {
    
    public static func httpRequest(url: String, method: HTTPMethod, parameters: [String:String], completion: @escaping (Int, Dictionary<String, Any> ) -> Void ) {
        let headers:HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        
        AF.request("\(Constants.HOST)\(url)", method: method, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseJSON { (response) in
            
            var finalStatus = 500
            var finalJson:[String: Any] = [:]
            
            switch response.result {
            case .failure(_):
                finalJson = ["error": Constants.GENERIC_ERROR]
            case .success(let json):
                finalJson = json as! Dictionary<String, Any>
                
                if let status = response.response?.statusCode {
                    finalStatus = status
                }
            }
            completion(finalStatus, finalJson)
        }
    }
}
