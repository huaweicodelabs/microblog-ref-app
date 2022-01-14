/*
**********************************************************************************
| |
| Copyright 2021. Huawei Technologies Co., Ltd. All rights reserved. |
| |
| Licensed under the Apache License, Version 2.0 (the "License"); |
| you may not use this file except in compliance with the License. |
| You may obtain a copy of the License at |
| |
| http://www.apache.org/licenses/LICENSE-2.0 |
| |
| Unless required by applicable law or agreed to in writing, software |
| distributed under the License is distributed on an "AS IS" BASIS, |
| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. |
| See the License for the specific language governing permissions and |
| limitations under the License. |
| |
**********************************************************************************
*/


import Foundation


class HttpRequest {
    
    static let shared = HttpRequest()
    
    func reqestGetData(url: String, method: HTTPMethod, bodyData: Data?=nil, response: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        
        guard let url = URL(string: url) else {
            print("HttpRequest: url is nil")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let data = bodyData {
            request.httpBody = data
        }
        
        URLSession.shared.dataTask(with: request, completionHandler: response).resume()
    }
    func apiReqest(url: String, method: HTTPMethod, headerFields:[String: String?]?=nil, bodyData: Data?=nil, completionHandler: @escaping ([String:Any]?, URLResponse?, Error?) -> Void) {
        
        
        guard let url = URL(string: url) else {
            print("HttpRequest: url is nil")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headerFields?.forEach{ key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let data = bodyData {
            request.httpBody = data
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error, onComplete: completionHandler)
        }
        task.resume()
    }
    
    
    func reqest(url: String, method: HTTPMethod, body: [String: Any]?=nil, bodyType: HTTPBodyType = .raw, response: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            print("HttpRequest: url is nil")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch bodyType {
        case .raw:
            if let body = body {
                let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = bodyData
            }
        case .x_www_form_encoding:
            var bodyString: String = ""
            body?.forEach{ key, value in
                bodyString += "\(key)=\(value)&"
            }
            if bodyString.last == "&" { _ = bodyString.popLast() }
            
            if !bodyString.isEmpty {
                request.httpBody = bodyString.data(using: .utf8)
            }
        }
        
        URLSession.shared.dataTask(with: request, completionHandler: response).resume()
    }
    
    
    
    func apiReqest(url: String, method: HTTPMethod, body: [String: Any]?=nil, bodyType: HTTPBodyType = .raw, completionHandler: @escaping ([String: Any]?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            print("HttpRequest: url is nil")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch bodyType {
        case .raw:
            if let body = body {
                let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = bodyData
            }
        case .x_www_form_encoding:
            var bodyString: String = ""
            body?.forEach{ key, value in
                bodyString += "\(key)=\(value)&"
            }
            if bodyString.last == "&" { _ = bodyString.popLast() }
            
            if !bodyString.isEmpty {
                request.httpBody = bodyString.data(using: .utf8)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error, onComplete: completionHandler)
        }
        task.resume()
    }
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?, onComplete: ([String:Any]?, URLResponse?, Error?)->Void)  {
        if let data = data {
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dict = jsonObject as? [String: Any] {
                print("response: \(dict)")
                onComplete(dict, response, error)
            } else {
                onComplete([:], response, error)
            }
        }
        else {
            onComplete([:], response, error)
        }
    }
    
    

}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum HTTPBodyType {
    case raw
    case x_www_form_encoding
}
