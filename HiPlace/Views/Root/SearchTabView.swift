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

struct SearchTabView: View {
    @State var searchText = ""
    @ObservedObject var viewModel = SearchViewModel(config: .search)
    
    var body: some View {
        NavigationView {
            ScrollView {
                SearchBar(text: $searchText)
                    .padding()
                    .onChange(of: searchText, perform: { newSearchText in
                        DispatchQueue.main.async {
                            viewModel.fetchUsers(by: newSearchText)
                        }
                    })
                
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.users, id: \.self) { user in
                            NavigationLink(
                                destination: LazyView(UserProfileView(user: user)),
                                label: {
                                    HStack {
                                        UserCell(user: user)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 10)
                                })
                            Divider()
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Search", displayMode: .inline)
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTabView()
    }
}
