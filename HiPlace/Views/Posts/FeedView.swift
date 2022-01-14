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

struct FeedView: View {
    @ObservedObject var viewModel = FeedViewModel()
    @State private var isShowingNewPostView: Bool = false
    @State var redactionReason = RedactionReasons.init()

    var body: some View {
        ZStack{
            ZStack(alignment: .bottomTrailing) {
                
                RefreshScrollView(content:
                        VStack {
                            ForEach(viewModel.posts, id: \.id) { post in
                                PostCell(post: post)
                            }
                        },
                        onUpdate: { onComplete in
                            self.redactionReason = .placeholder
                            viewModel.fetchPosts() {
                                self.redactionReason = RedactionReasons.init()
                                onComplete()
                            }
                        }
                )
                
                NewPostFloatingActionButton()
            }
            
            BannerView(title: viewModel.alert.title, detail: viewModel.alert.detail, type: viewModel.alert.bannerType, showBanner: $viewModel.alert.showBannerMessge)
        }
    }
    
    func NewPostFloatingActionButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                isShowingNewPostView.toggle()
            }, label: {
                Image("tweet")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding()
                
            })
            .background(Color(.systemGreen))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .fullScreenCover(isPresented: $isShowingNewPostView) {
                NewPostView(isPresented: $isShowingNewPostView, onSentSuccessfully: { viewModel.fetchPosts() })
            }
        }
    }

}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
