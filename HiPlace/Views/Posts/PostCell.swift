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

struct PostCell: View {
    var post: Post
    @State private var user: UserInfo?
    @ObservedObject private var viewModel: PostViewModel
    @ObservedObject private var postActionsViewModel: PostActionsViewModel

    init(post: Post) {
        self.post = post
        self.viewModel = PostViewModel()
        self.postActionsViewModel = PostActionsViewModel(post: self.post)
        
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if let user = user {
                NavigationLink(
                    destination: LazyView(UserProfileView(user: user)),
                    label: {
                        ProfileImageView(imageUrl: user.profileImageUrl, width: 56, height: 56)
                    })
                } else {
                    ProfileImageView(imageUrl: user?.profileImageUrl, width: 56, height: 56)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(user?.fullName ?? "")
                            .font(.system(size: 15, weight: .semibold))
                        
                        Group {
                            Text("@\(user?.username ?? "") •")
                            Text(post.timestampString)
                        }
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                    }
                    
                    Text(post.caption.text)
                        .font(.system(size: 15))

                }
                Spacer()
            }
            .padding(.ArrayLiteralElement(arrayLiteral: [.horizontal, .top]))
            .padding(.bottom, 2)

            PostActionsView(post: post, viewModel: postActionsViewModel)
            
            Divider()
        }
        .onAppear() {
            viewModel.fetchUser(uid: post.userUid, user: $user)
        }
    
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: Post())
    }
}

