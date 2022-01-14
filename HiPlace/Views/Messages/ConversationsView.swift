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

struct ConversationsView: View {
    
    @ObservedObject var viewModel: ConversationsViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.recentConversations, id:\.self) { conservation in
                        NavigationLink(
                            destination: LazyView(ChatView(chattingWith: conservation.user)),
                            label: {
                                ConversationCell(conservation: conservation).id(conservation.message.id)
                            })
                    }
                }
                .padding(.vertical)
            }
            
            
           
        }
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView(viewModel: ConversationsViewModel())
    }
}
