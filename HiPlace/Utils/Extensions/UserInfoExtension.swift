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

extension UserInfo {
    enum FieldName: CaseIterable {
        static let email = "email"
        static let uid = "uid"
        static let fullName = "fullName"
        static let username = "username"
        static let profileImageUrl = "profileImageUrl"
    }

    convenience init(uid: String?=nil, email: String?=nil, fullName: String?=nil, username:  String?=nil, profileImageUrl:  String?=nil)  {
        self.init()
        
        if let uid = uid { self.uid = uid }
        if let email = email { self.uid = email }
        if let fullName = fullName { self.fullName = fullName }
        if let username = username { self.username = username }
        if let profileImageUrl = profileImageUrl { self.profileImageUrl = profileImageUrl }
    }
    
    var isCurrentUser: Bool {
        return AuthService.shared.userSession?.uid == self.uid
    }
    
    open override var description: String {
        return "UserInfo(" +
            "uid: \(uid), " +
            "email: \(email), " +
            "fullName: \(fullName), " +
            "username: \(username), " +
            "profileImageUrl: \(profileImageUrl)" +
            ")"
    }
       
//    var followingCountString: String? {
//        return MyClassObjectiveC.convert(toString: followingCount)
//    }
//    var followersCountString: String? {
//        return MyClassObjectiveC.convert(toString: followersCount)
//    }
}
