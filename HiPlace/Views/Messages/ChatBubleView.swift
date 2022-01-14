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

struct ChatBubleView: View {
    let message: Message
    let user: UserInfo
    
    init(message: Message, chattingWith: UserInfo) {
        self.message = message
        self.user = chattingWith
    }
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser() {
                Spacer()
                Text(message.message.text)
                    .padding()
                    .background(Color(.accent))
                    .clipShape(ChatBubbleShape(isFromCurrentUser: true))
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(.leading, 100)
                    .padding(.trailing, 16)
                
            } else {
                
                HStack(alignment: .bottom) {
                    ProfileImageView(imageUrl: user.profileImageUrl, width: 40, height: 40)
                    
                    Text(message.message.text)
                        .padding()
                        .background(Color(.systemGray5))
                        .clipShape(ChatBubbleShape(isFromCurrentUser: false))
                        .foregroundColor(Color(.label))
                        .font(.system(size: 16))
                        
                }
                .padding(.leading, 16)
                .padding(.trailing, 100)
                Spacer()
            }
        }
        
    }
}

struct ChatBubleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubleView(message: Message(), chattingWith: UserInfo())
    }
}
