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

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoading = true
    @Published var alert = HiPlaceAlert()

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchPosts()
        }
    }
    
    func fetchPosts(onComplete: (() -> Void)? = nil) {
        DispatchQueue.main.async { self.isLoading = true }
        let query = AGCCloudDBQuery.where(Post.classForCoder()).order(byDesc: "timeStamp")
        CloudDBHelper.instance.query(query, Post.self) { posts, error in
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                print("DEBUG:: fetchPosts: error: \(error.localizedDescription)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.alert.showBanner(title: "Error", detail: error.localizedDescription, type: .error) }
                onComplete?()
                return
            }
            if let posts = posts, self.posts.first?.id != posts.first?.id {
                DispatchQueue.main.async {
                    self.posts = posts
                    onComplete?()
                }
            }
        }
    }
}
