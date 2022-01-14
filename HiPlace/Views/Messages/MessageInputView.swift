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

struct MessageInputView: View {
    @Binding var messageText: String
    var placeHolderText = "Message..."
    let action: () -> Void
    
    var body: some View {
        HStack {
            DynamicTextAreaView(text: $messageText, placeholder: placeHolderText, lineLimit: 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
         
            Button(action: action, label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color(.systemGreen))
                    .background((Color.white))
                    .clipShape(Circle())
                    .rotationEffect(.init(degrees: 45))
            })
        }
        
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView(messageText: .constant("Hello"), action: {})
            .preferredColorScheme(.dark)
    }
}
