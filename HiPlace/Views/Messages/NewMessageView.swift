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

struct NewMessageView: View {
    @State var searchText = ""
    @Binding var show: Bool
    @Binding var isStartChat: Bool
    @ObservedObject var viewModel = SearchViewModel(config: .newMessage)
    @Binding var user: UserInfo?

    var body: some View {
        ScrollView {
            SearchBar(text: $searchText)
                .onChange(of: searchText, perform: { newSearchText in
                    DispatchQueue.main.async {
                        viewModel.fetchUsers(by: newSearchText)
                    }
                })
                .padding()
            
            
            HStack {
                VStack(alignment: .leading) {
                    ForEach(viewModel.users, id: \.self) { user in
                        Button(action: {
                            self.user = user
                            self.show.toggle()
                            self.isStartChat.toggle()
                        }, label: {
                            UserCell(user: user)
                        })
                    }
                }
                .padding(.leading)
                Spacer()
            }
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView(show: .constant(true), isStartChat: .constant(true), user: .constant(UserInfo()))
    }
}
