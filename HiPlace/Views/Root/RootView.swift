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

struct RootView: View {
    init() {
        // UINavigationBar.appearance().titleTextAttributes =  [.foregroundColor : UIColor.systemGreen]
    }
    @EnvironmentObject private var authService: AuthService

    var body: some View {
        ZStack {
            if authService.userSession != nil {
                TabView {
                    HomeTabView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    SearchTabView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    
                    MessagesTabView()
                        .tabItem {
                            Label("Messages", systemImage: "envelope")
                        }
                }
                .accentColor(Color(.systemGreen))
            } else {
                LoginView()
            }
            
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            
    }
}
