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

struct SmallLoadingIndicatorView: View {
    var body: some View {
        ZStack {
            
            Color(.label).colorInvert().opacity(0.4).ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(.label)))
                .scaleEffect(2)
        }
    }
}

struct SmallLoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        SmallLoadingIndicatorView()
    }
}
