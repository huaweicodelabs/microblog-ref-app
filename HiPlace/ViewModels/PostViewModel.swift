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

import SwiftUI

class PostViewModel: ObservableObject {
    
    func fetchUser(uid: String, user: Binding<UserInfo?>)  {
        DispatchQueue.main.async {
            let query = AGCCloudDBQuery.where(UserInfo.classForCoder()).equal(to: uid, forField: UserInfo.FieldName.uid)
            CloudDBHelper.instance.query(query, UserInfo.self) { data, error in
                if let error = error {
                    print("DEBUG:: fetchUser for post: error: \(error.localizedDescription)")
                }
                if user.wrappedValue != nil {return}
                if let fetchedUser = data?.first {
                    DispatchQueue.main.async {
                        user.wrappedValue = fetchedUser
                    }
                }
            }
        }
    }
}
