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

struct ProfileActionButtonView: View {
    
    let viewModel: ProfileViewModel
    @Binding var isFollowed: Bool
    
    var body: some View {
        VStack {
            if viewModel.user.isCurrentUser {
                Button(action: {}, label: {
                    Text("Edit Profile")
                        .frame(width: 360, height: 40)
                        .background(Color(.systemGreen))
                        .foregroundColor(.white)
                })
                .cornerRadius(20)
                .shadow(radius: 6)
            }
            else {
                HStack {
                    Button(action: {
                        isFollowed ? viewModel.unfollow() : viewModel.follow()
                    }, label: {
                        Text(isFollowed ? "Following" : "Follow")
                            .frame(width: 180, height: 40)
                            .background(Color(.systemGreen))
                            .foregroundColor(.white)
                    })
                    .cornerRadius(20)
                    .shadow(radius: 6)
                    
                    NavigationLink(
                        destination: LazyView(ChatView(chattingWith: viewModel.user)),
                        label: {
                            Text("Message")
                                .frame(width: 180, height: 40)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(radius: 6)
                        })
                }
            }
        }
    }
}

struct ProfileActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileActionButtonView(viewModel: ProfileViewModel(user:  UserInfo(uid: "123", email: "test@test.com", fullName: "Test User", username: "testuser", profileImageUrl: "")), isFollowed: .constant(false))
    }
}
