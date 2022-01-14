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
import Kingfisher

struct UserCell: View {
    var user: UserInfo

    var body: some View {
        HStack(spacing: 12) {
            ProfileImageView(imageUrl: user.profileImageUrl, width: 56, height: 56)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.system(size: 14, weight: .semibold))
                
                Text("@\(user.username)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .foregroundColor(Color(.label))
            
        }
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {        
        UserCell(user: UserInfo(uid: "123", email: "test@test.com", fullName: "Test User", username: "testuser", profileImageUrl: ""))
    }
}
