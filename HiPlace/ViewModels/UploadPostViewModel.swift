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

class UploadPostViewModel: ObservableObject {
    
    func uploadPost(text: String, completion: @escaping (Error?) -> Void) {
        guard let uid = AuthService.shared.userSession?.uid else {return}
        let post = Post()
        post.id = UUID().uuidString
        post.userUid = uid
        post.caption = AGCCloudDBText.createText(text)
        post.likeCount = NSNumber(0)
        post.timeStamp = Date()
        
        CloudDBHelper.instance.upsertOne(data: post, completion: completion)
    }
}
