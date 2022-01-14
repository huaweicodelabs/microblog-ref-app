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

class SearchViewModel: ObservableObject {
    enum Configuration {
        case newMessage
        case search
    }
    
    @Published var users = [UserInfo]()
    let config: Configuration
    
    init(config: Configuration) {
        self.config = config
        self.fetchUsers()
    }
    
    func fetchUsers(by searchText: String, limit: Int32 = 25) {
        guard let currentUser = AuthService.shared.user else { return }
        let query = AGCCloudDBQuery.where(UserInfo.classForCoder())
        
        if !searchText.isEmpty {
            query.contains(searchText, forField: UserInfo.FieldName.username)
        }
        
        switch self.config {
        case .search:
            query.limit(limit)
            
        case .newMessage:
            // show users except user self
            query.notEqual(to: currentUser.uid, forField: UserInfo.FieldName.uid)
                .limit(limit)
        }
        
        CloudDBHelper.instance.query(query, UserInfo.self) { fetchedUsers, error in
            if let error = error {
                print("DEBUG:: fetchUsers Error: \(error.localizedDescription)")
                return
            }
            guard let fetchedUsers = fetchedUsers else {return}
            DispatchQueue.main.async {
                self.users = fetchedUsers
            }
        }
    }
    
    func fetchUsers() {
        fetchUsers(by: "")
    }
}
