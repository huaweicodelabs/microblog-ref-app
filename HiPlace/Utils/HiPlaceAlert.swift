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

class HiPlaceAlert: ObservableObject {
    
    static let shared = HiPlaceAlert()

    @Published var title = "Title"
    @Published var detail = "your message"
    @Published var image = ""
    @Published var bannerType : BannerType = .warning
    @Published var showBannerMessge = false
    @Published var showToastMessage = false
    @Published var showLoadingIndicator = false

    func showLoadingIndicator(_ bool: Bool) {
        DispatchQueue.main.async {
            self.showLoadingIndicator = bool
        }
    }
    
    func showBanner(title: String?=nil, detail: String?=nil, type: BannerType?=nil) {
        DispatchQueue.main.async {
            endEditing()
            if let theTitle = title {self.title = theTitle}
            if let theDetail = detail {self.detail = theDetail}
            if let theType = type {self.bannerType = theType}
            self.showBannerMessge = true
        }
    }
    
    func showToast(title: String?=nil, image: String?=nil) {
        DispatchQueue.main.async {
            endEditing()
            if let theTitle = title {self.title = theTitle}
            if let theImage = image {self.image = theImage}
            self.showToastMessage = true
        }
    }
}
