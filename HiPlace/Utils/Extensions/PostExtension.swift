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


import Foundation

extension Post {
    enum FieldName: CaseIterable {
        static let id = "id"
        static let userUid = "userUid"
        static let caption = "caption"
        static let likeCount = "likeCount"
        static let timeStamp = "timeStamp"
    }
    convenience init(id: String?=nil, userUid: String?=nil, caption:String?=nil, likeCount: Int?=nil, timeStamp: Date?=nil)  {
        self.init()
        if let id = id { self.id = id }
        if let userUid = userUid { self.userUid = userUid }
        if let caption = caption { self.caption = AGCCloudDBText.createText(caption) }
        if let likeCount = likeCount { self.likeCount = NSNumber(value: likeCount) }
        if let timeStamp = timeStamp { self.timeStamp = timeStamp }
    }
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timeStamp, to: Date()) ?? ""
    }
    
    var detailedTimestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · dd/MM/yyyy"
        return formatter.string(from: timeStamp)
    }
}
