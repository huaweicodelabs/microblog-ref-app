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

struct ProfileImageView: View {
    
    @State var imageUrl: String?
    var width: CGFloat=35
    var height: CGFloat=35
    
    var showAuthenticatedUser = false
    
    
    var body: some View {
        if let profileImageUrl = imageUrl,
           !profileImageUrl.isEmpty,
           let url = URL(string: profileImageUrl) {
            KFImage(url)
                .resizable()
                .clipShape(Circle())
                .scaledToFill()
                .frame(width: width, height: height)
        }
        else if showAuthenticatedUser {
            if let url = AuthService.shared.user?.profileImageUrl, !url.isEmpty {
                KFImage(URL(string: url))
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: width, height: height)
            } else {
                DefaultImage()
                    .onReceive(AuthService.shared.$user) { user in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.imageUrl = AuthService.shared.user?.profileImageUrl
                    }
                }
            }
            
        }
        else {
            DefaultImage()
        }
    }
    
    func DefaultImage() -> some View {
        Image(systemName: "person.crop.circle")
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .foregroundColor(.gray)
            .background(Color.white)
            .clipShape(Circle())
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(imageUrl: ("https://firebasestorage.googleapis.com:443/v0/b/twitter---clone-368a0.appspot.com/o/479967A8-A635-4C3B-A54C-4DD8955CE68D?alt=media&token=1228542a-d6b6-47d8-8994-5b0c9155eb0b"), width: 120, height: 120)
    }
}
