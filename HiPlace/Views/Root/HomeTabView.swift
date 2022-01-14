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

struct HomeTabView: View {
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                FeedView()
                    .navigationBarTitle("Home", displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {
                        showingAlert = true

                    }, label: {
                        AlertView(title: "Sign Out", message: "Do you really want to sign out?", primaryButton: "Sign Out", showAlert:  $showingAlert) {
                            ProfileImageView(showAuthenticatedUser: true)
                        }
                        primaryButtonAction: {
                            AuthService.shared.signOut()
                        }
                    })
                    )
                
                    
                
            }
        }
        
    }
    
    
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}

