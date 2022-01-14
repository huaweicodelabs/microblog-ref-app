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
import AGConnectAuth

class AuthService: ObservableObject {
    enum ErrorCode: Int {
        case verifyCodeAlreadySent = 203818048 // "verify code within send interval"
    }
    
    static let shared = AuthService()
   
    private init() {
        userSession = AGCAuth.instance().currentUser
        fetchUser()
    }

    @Published var userSession: AGCUser?
    @Published var user: UserInfo?
    
    private var sendInterval = 30
    
    func fetchUser() {
        DispatchQueue.main.async {
        
            guard let uid = AGCAuth.instance().currentUser?.uid else {return}
            let query = AGCCloudDBQuery.where(UserInfo.classForCoder()).equal(to: uid, forField: "uid")
            CloudDBHelper.instance.query(query, UserInfo.self) { data, error in
                if let error = error {
                    print("DEBUG:: AuthService ERROR: \(error)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.fetchUser()
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    AuthService.shared.user = data?.first
                    
                    if let user = AuthService.shared.user, let huaweiToken = huaweiToken, user.pushToken != huaweiToken {
                        user.pushToken = huaweiToken
                        CloudDBHelper.instance.upsertOne(data: user)
                    }
                }
            }
        }
    }
    
    func login(withEmail email: String, password: String, onSuccess: ((AGCSignInResult?)->Void)?=nil, onFailure: ((Error?)->Void)?=nil) {
        let task = AGCAuth.instance().signIn(credential: AGCEmailAuthProvider.credential(withEmail: email, password: password))
            
        if let onSuccess = onSuccess {
            task.onSuccess(callback: onSuccess)
        }
        if let onFailure = onFailure {
            task.onFailure(callback: onFailure)
        }
    }
    
    func verifyUser(email:String, config: SettingConfig, onSuccess: ((AGCVerifyCodeResult?)->Void)?=nil, onFailure: ((Error)->Void)?=nil) {
        let setting = getSetting(config: config)
        let task = AGCAuth.instance().requestVerifyCode(withEmail: email, settings:setting)
        if let onSuccess = onSuccess {
            task.onSuccess(callback: onSuccess)
        }
        if let onFailure = onFailure {
            task.onFailure(callback: onFailure)
        }
    }
    
    enum SettingConfig {
        case registerLogin
        case resetPassword
    }
    
    func getSetting(config: SettingConfig) -> AGCVerifyCodeSettings {
        switch config {
        case .registerLogin:
            return AGCVerifyCodeSettings.init(action:AGCVerifyCodeAction.registerLogin, locale:nil, sendInterval:sendInterval)
        case .resetPassword:
            return AGCVerifyCodeSettings.init(action:AGCVerifyCodeAction.resetPassword, locale:nil, sendInterval:sendInterval)
        }
    }
    
    func createUser(userData: RegistrationModel, verifyCode: String, onSuccess: ((AGCSignInResult?)->Void)?=nil, onFailure: ((Error?)->Void)?=nil) {
        let task = AGCAuth.instance().createUser(withEmail: userData.email, password: userData.password, verifyCode: verifyCode)
        if let onSuccess = onSuccess {
            task.onSuccess(callback: onSuccess)
        }
        if let onFailure = onFailure {
            task.onFailure(callback: onFailure)
        }
    }
    
    func resetPassword(email: String, password: String, verifyCode: String, onSuccess: ((AnyObject?)->Void)?=nil, onFailure: ((Error)->Void)?=nil) {
        
        let task = AGCAuth.instance().resetPassword(withEmail: email, newPassword: password, verifyCode: verifyCode)
        if let onSuccess = onSuccess {
            task.onSuccess(callback: onSuccess)
            AnalyticsService.shared.onEvent("passwordReset", setParams: ["email": email,"message":"success"]);
        }
        if let onFailure = onFailure {
            task.onFailure(callback: onFailure)
        }
    }
    
    func signOut() {
        AGCAuth.instance().signOut()
        self.userSession = nil
        self.user = nil
    }
}
