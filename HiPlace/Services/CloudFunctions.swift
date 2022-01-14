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
import AGConnectFunction

//
// MARK: FUNCTION URIs FROM AGC CLOUD FUNCTIONS
//
extension CloudFunctions {
    static let FETCH_PROFILE_USER_DETAILS = "fetch-profile-user-details-$latest"
}

//
// MARK: CloudFunctions
//
class CloudFunctions {
    static let shared = CloudFunctions()
    
    private init() {}
    
    private func function(httpTriggerUri: String) -> Task<AGCFunctionResult> { AGCFunction.getInstance().wrap(httpTriggerUri).call() }
    
    private func function(httpTriggerUri: String, with dict: [String: Any]) -> Task<AGCFunctionResult> { AGCFunction.getInstance().wrap(httpTriggerUri).call(with: dict as NSDictionary) }
   
    private func function(httpTriggerUri: String, with object: Any?) -> Task<AGCFunctionResult> { AGCFunction.getInstance().wrap(httpTriggerUri).call(with: object) }
   
   func call(httpTriggerUri: String, onComplete: ((Task<AGCFunctionResult>)->Void)?=nil, onSuccess: ((AGCFunctionResult?)->Void)?=nil, onFailure: ((Error)->Void)?=nil)  {
        function(httpTriggerUri: httpTriggerUri).addListeners(onComplete: onComplete, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func call(httpTriggerUri: String, with dict: [String: Any], onComplete: ((Task<AGCFunctionResult>)->Void)?=nil, onSuccess: ((AGCFunctionResult?)->Void)?=nil, onFailure: ((Error)->Void)?=nil) {
        function(httpTriggerUri: httpTriggerUri, with: dict).addListeners(onComplete: onComplete, onSuccess: onSuccess, onFailure: onFailure)
     }
    
    func call(httpTriggerUri: String, with object: Any?, onComplete: ((Task<AGCFunctionResult>)->Void)?=nil, onSuccess: ((AGCFunctionResult?)->Void)?=nil, onFailure: ((Error)->Void)?=nil) {
        function(httpTriggerUri: httpTriggerUri, with: object).addListeners(onComplete: onComplete, onSuccess: onSuccess, onFailure: onFailure)
     }
}

//
// MARK: EXTEND TASK TO ADD LISTENERS EASILY
//
extension Task {
    @objc func addListeners(onComplete: ((Task<AGCFunctionResult>)->Void)?=nil, onSuccess: ((AGCFunctionResult?)->Void)?=nil, onFailure: ((Error)->Void)?=nil) {
        guard let _self = self as? Task<AGCFunctionResult> else {return}
        if let onComplete = onComplete {
            _self.onComplete(callback: onComplete)
        }
        if let onSuccess = onSuccess {
            _self.onSuccess(callback: onSuccess)
        }
        if let onFailure = onFailure {
            _self.onFailure(callback: onFailure)
        }
    }
}
