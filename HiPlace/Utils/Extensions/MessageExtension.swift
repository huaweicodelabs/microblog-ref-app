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

extension Message {
    enum FieldName: CaseIterable {
        static let id = "id"
        static let fromUserUid = "fromUserUid"
        static let toUserUid = "toUserUid"
        static let message = "message"
        static let timestamp = "timestamp"
    }
    
    convenience init(fromUserUid: String, toUserUid: String, message: String, id: String, timestamp: Date) {
        self.init()
        self.id = id
        self.fromUserUid = fromUserUid
        self.toUserUid = toUserUid
        self.message = AGCCloudDBText.createText(message)
        self.timestamp = timestamp
    }
    
    func toRecentMessage() -> RecentMessage {
        return RecentMessage(fromUserUid: fromUserUid, toUserUid: toUserUid, message: message.text, messageId: id, timestamp: timestamp)
    }
    
    func isFromCurrentUser() -> Bool {
        return fromUserUid == AuthService.shared.userSession?.uid
    }
    
    open override var description: String {
        return "Message(" +
            "id: \(id), " +
            "fromUserUid: \(fromUserUid), " +
            "toUserUid: \(toUserUid), " +
            "message: \(message.text), " +
            "timestamp: \(timestamp.description)" +
            ")"
    }
}
