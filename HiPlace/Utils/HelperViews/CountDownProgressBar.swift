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

struct CountDownProgressBar: View {
    var seconds: Int
    @Binding var timer: Int
   // @Binding var progress: Float
    var width: CGFloat = 200
    var height: CGFloat = 200
    var lineWidth: CGFloat = 20
    var text: String = ""
    var color = Color.white

    var getText: String {
        if self.text.isEmpty {
            let progress  = 100 * Float(timer / seconds)
           return String(format: "%.0f %%", min(progress, 1.0)*100.0)
        }
        return text
    }
    
    var progress: Float {
        return ( Float(timer)) / Float(seconds)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(color)
                .frame(width: width, height: height)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.interactiveSpring())
                .frame(width: width, height: height)

            Text(String(timer))
                .font(.largeTitle)
                .bold()
        }
        .padding()
    }
}

struct CountDownProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CountDownProgressBar(seconds: 100, timer: .constant(1), color: .yellow)
    }
}
