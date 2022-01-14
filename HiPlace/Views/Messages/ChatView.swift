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

struct ChatView: View {
    var user: UserInfo
    @ObservedObject var viewModel: ChatViewModel
    @State var messageText: String = ""
    @StateObject var alert = HiPlaceAlert()

    init(chattingWith: UserInfo) {
        self.user = chattingWith
        viewModel = ChatViewModel(chattingWith: self.user)      
    }
        
    var body: some View {
        ZStack {
            BannerView(title: alert.title, detail: alert.title, type: alert.bannerType, showBanner: $alert.showBannerMessge)
            
            VStack {
                ScrollView {
                    ScrollViewReader { scrollView in
                        VStack {
                            ForEach(viewModel.messages, id: \.id) { message in
                                ChatBubleView(message: message, chattingWith: self.user)
                                    .id(message.id)
                            }
                        }
                        .padding(.vertical)
                        .onChange(of: viewModel.messages) { _ in
                            scrollView.scrollTo(viewModel.messages.last?.id)
                        }
                        .onAppear() {
                            scrollView.scrollTo(viewModel.messages.last?.id)
                            viewModel.scrollViewProxy = scrollView
                        }
                        
                    }
                }

                
                MessageInputView(messageText: $messageText, action: sendMessage)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6).opacity(0.4))
                    .clipShape(CustomCorderRadiusShape(corners: [.topLeft, .topRight], radius: 8))
            }
            .navigationTitle(user.username)
            .onDisappear() {
                viewModel.stopListening()
            }
            
            if viewModel.isLoading {
                SmallLoadingIndicatorView()
            }
        }
        
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
        return Path(path.cgPath)
    }
    
    func sendMessage() {
        viewModel.sendMessage(messageText) { error in
            if let error = error {
                alert.showBanner(title: "Error !!", detail: error.localizedDescription, type: .error)
                return
            }
            messageText = ""
        }
    }
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chattingWith: UserInfo())
        
    }
}
