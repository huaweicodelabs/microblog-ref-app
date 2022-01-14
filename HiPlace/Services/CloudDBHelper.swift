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
import AGConnectDatabase

class CloudDBHelper {
    
    private init() {}
    
    static let zoneName = "HiPlaceDB"
    static let instance = CloudDBHelper()
     
    
    func getZoneConfig(zoneName: String, syncMode: AGCCloudDBZoneSyncMode = .cloudCache) -> AGCCloudDBZoneConfig {
        return AGCCloudDBZoneConfig(zoneName: zoneName, syncMode: syncMode, accessMode: .public)
    }
    
    func getZoneConfig(syncMode: AGCCloudDBZoneSyncMode = .cloudCache) -> AGCCloudDBZoneConfig {
        return getZoneConfig(zoneName: CloudDBHelper.zoneName, syncMode: syncMode)
    }
    
    func openZoneAsync(completion: @escaping (AGCCloudDBZone?, Error?) -> Void) {
        DispatchQueue.main.async {
            AGConnectCloudDB.shareInstance().openZone2(self.getZoneConfig(), allowCreate: true) { dbZone, error in
                if let error = error {
                    print("DEBUG:: openZoneAsync: error: \(error.localizedDescription)")
                }
                completion(dbZone, error)
            }
        }
    }
    
    func deleteOne<T: AGCCloudDBObject>(data: T, completion: ((Int?, Error?) -> Void)?=nil) {
        DispatchQueue.main.async {
            self.openZoneAsync { dbZone, error in
                if let error = error { completion?(nil, error); return }
                dbZone?.executeDeleteOne(data) { count, error in
                    if let error = error {
                        print("DEBUG:: executeDeleteOne: error: \(error.localizedDescription)")
                    }
                    completion?(count, error)
                    if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                }
            }
        }
    }
    
    func upsertOne<T: AGCCloudDBObject>(data: T, completion: ((Error?) -> Void)?=nil) {
        DispatchQueue.main.async {
            AGConnectCloudDB.shareInstance().openZone2(self.getZoneConfig(), allowCreate: true) { dbZone, error in
                if let error = error { completion?(error); return }
                dbZone?.executeUpsertOne(data) { _, error in
                    if let error = error {
                        print("DEBUG:: executeUpsertOne: error: \(error.localizedDescription)")
                    }
                    completion?(error)
                    if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                }
            }
        }
    }
    
    func query<T: AGCCloudDBObject>(_ query: AGCCloudDBQuery, _ ofType: T.Type,  completion: (([T]?, Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            AGConnectCloudDB.shareInstance().openZone2(self.getZoneConfig(), allowCreate: true) { dbZone, error in
                if let error = error {
                    if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                    completion?(nil, error)
                    return
                }
                dbZone?.execute(query, policy: AGCCloudDBQueryPolicy.cloud) { snapshot, error in
                    if let error = error {
                        completion?(nil, error)
                        if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                        return
                    }
                    
                    let data = snapshot?.snapshotObjects() as? [T]
                    completion?(data, nil)
                    if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                }
            }
        }
    }
    
    func queryUser(username: String, complete: ((UserInfo?, Error?) -> Void)? = nil) {
        DispatchQueue.main.async {
            AGConnectCloudDB.shareInstance().openZone2(self.getZoneConfig(), allowCreate: true) { dbZone, error in
                if let error = error {
                    complete?(nil, error)
                    if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                    return
                }
                
                let query = AGCCloudDBQuery.where(UserInfo.classForCoder()).contains(username, forField: "username")
                dbZone?.execute(query, policy: AGCCloudDBQueryPolicy.cloud) { snapshot, error in
                    if let error = error {
                        complete?(nil, error)
                        if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                        return
                    }
                    
                    let user = snapshot?.snapshotObjects().first as? UserInfo
                    complete?(user, nil)
                    if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                }
            }
        }
    }
    
    func getCount(query: AGCCloudDBQuery, fieldName: String, completion: @escaping (Int?, Error?) -> Void ) {
        DispatchQueue.main.async {
            self.openZoneAsync { dbZone, error in
                dbZone?.executeQueryCount(query, policy: .cloud, field: fieldName, onCompleted: { count, error in
                    completion(count, error)
                    if let dbZone = dbZone { AGConnectCloudDB.shareInstance().close(dbZone, error: nil) }
                })
            }
        }
    }
    
    func listenData<T: AGCCloudDBObject>(query: AGCCloudDBQuery, typeOf: T.Type, listenerHandler: UnsafeMutablePointer<AGCCloudDBListenerHandler?>, completion: @escaping ([T]?, Error?) -> Void)  {
        CloudDBHelper.instance.openZoneAsync { dbZone, error in
            if let error = error {
                completion(nil, error)
                return
            }
            listenerHandler.pointee = dbZone?.subscribeSnapshot(with: query, policy: .cloud, listener: { snapshot, error in
                guard let changes = snapshot?.snapshotObjects() as? [T] else {return}
                completion(changes, error)
            })
        }
    }
}

