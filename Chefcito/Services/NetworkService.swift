//
//  NetworkService.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 14/11/20.
//

import Foundation
import Alamofire
 
struct NetWorkService {
    
    public static func httpRequest(url: String, method: HTTPMethod, parameters: [String:String], headers:HTTPHeaders, completion: @escaping (Int, Dictionary<String, Any> ) -> Void ) {
        
        AF.request("\(Constants.HOST)\(url)", method: method, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseJSON { (response) in
            let parseResponse = self.parseHttpResponse(response: response)
            let finalStatus:Int = parseResponse["finalStatus"] as! Int
            let finalJson:[String: Any] = parseResponse["finalJson"] as! [String : Any]
            completion(finalStatus, finalJson)
        }
    }
    
    public static func httpUpload (url: String, method:HTTPMethod, parameters: [String:String], data: Data, paramName: String, fileName: String, mimeType: String, completion: @escaping (Int, Dictionary<String, Any>) -> Void ) {
        AF.upload(multipartFormData: {multipartFormData in
            multipartFormData.append(data, withName: paramName, fileName: fileName, mimeType: mimeType)
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(Constants.HOST)\(url)", method: method ).responseJSON(completionHandler: { (response) in
            let parseResponse = self.parseHttpResponse(response: response)
            let finalStatus:Int = parseResponse["finalStatus"] as! Int
            let finalJson:[String: Any] = parseResponse["finalJson"] as! [String : Any]
            completion(finalStatus, finalJson)
        })
    }
    
    private static func parseHttpResponse (response: AFDataResponse<Any>) -> Dictionary<String, Any> {
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
        
        let result:[String: Any] = ["finalStatus": finalStatus, "finalJson": finalJson]
        return result
    }
}
