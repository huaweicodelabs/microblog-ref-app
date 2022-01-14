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

struct UserProfileView: View {
    @State var selectedFilter: FilterOptions = .posts
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(user: UserInfo) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileHeaderView(viewModel: viewModel, isFollowed: $viewModel.isFollowed)
                .padding()
                
                FilterButtonView(selectedOption: $selectedFilter)
                    //.frame(width: UIScreen.main.bounds.width)
                    .padding(.vertical)

                if selectedFilter == .posts {
                    ForEach(viewModel.userPosts, id: \.id) { post in
                        PostCell(post: post)
                    }
                } else if selectedFilter == .liked {
                    ForEach(viewModel.likedPosts, id: \.id) { post in
                        PostCell(post: post)
                    }
                }
                
            }
            .navigationTitle(viewModel.user.username)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user:  UserInfo(uid: "123", email: "test@test.com", fullName: "Test User", username: "testuser", profileImageUrl: ""))
    }
}
