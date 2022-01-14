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

struct DynamicTextAreaView: View {
    
    @Binding var text: String
    var placeholder = "Text..."
    var lineLimit: Int? = nil
    
    init(text: Binding<String>, placeholder:String?=nil, lineLimit: Int?=nil) {
        if let placeholder = placeholder { self.placeholder = placeholder }
        self._text = text
        self.lineLimit = lineLimit
        UITextView.appearance().backgroundColor = .clear
    }
    
    @State private var labelHeight : CGFloat = 35
    var body: some View {
        ZStack(alignment: .leading) {
            Text(text.isEmpty ? placeholder : text).foregroundColor(Color(.clear))
                .padding(.vertical, 10)
                .lineLimit(lineLimit)
                .background(GeometryReader {
                    Color(.clear).preference(key: ViewHeightKey.self, value:  $0.frame(in: .local).size.height)
                })
                .onPreferenceChange(ViewHeightKey.self) { value in
                    DispatchQueue.main.async {
                        labelHeight = value
                    }
                }

            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, 4)
                    .padding(.bottom, 3)
            }
            
            TextEditor(text: $text)
                .frame(maxHeight: labelHeight)
        }
        .padding(.horizontal, 4)
        .font(.body)
        
    }
    
    struct ViewHeightKey: PreferenceKey {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = value + nextValue()
        }
    }
}

struct DynamicTextAreaView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicTextAreaView(text: .constant(""))
    }
}
