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

struct MessagesTabView: View {
    @ObservedObject private var viewModel = ConversationsViewModel()
    @State var user: UserInfo?
    @State var isShowNewMessageView = false
    @State var isShowChat = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                if let user = user {
                    NavigationLink(
                        destination: LazyView(ChatView(chattingWith: user)),
                        isActive: $isShowChat,
                        label: {})
                }
                
                ScrollView {
                    VStack {
                        ForEach(viewModel.recentConversations, id:\.message.id) { conservation in
                            NavigationLink(
                                destination: LazyView(ChatView(chattingWith: conservation.user)),
                                label: {
                                    ConversationCell(conservation: conservation)
                                })
                        }
                    }
                    .padding(.vertical)
                }
                .onAppear() {
                    viewModel.startListening()
                }
                .onDisappear() {
                    viewModel.stopListening()
                }
                .blur(radius: viewModel.isLoading ? 2 : 0)

                NewMessageFloatingActionButton()
                
                if viewModel.isLoading {
                    SmallLoadingIndicatorView()
                }
            }
            .navigationBarTitle("Messages", displayMode: .inline)
        }
    }
    
    func NewMessageFloatingActionButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                self.isShowNewMessageView.toggle()
            }, label: {
                Image(systemName: "envelope")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding()
                
            })
            .background(Color(.systemGreen))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding()
            .sheet(isPresented: $isShowNewMessageView, content: {
                NewMessageView(show: $isShowNewMessageView, isStartChat: $isShowChat, user: $user)
            })
        }

    }
}


struct MessagesTabView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesTabView()
    }
}
