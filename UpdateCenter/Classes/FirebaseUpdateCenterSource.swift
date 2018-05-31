//
//  FirebaseSource.swift
//  UpdateCenter
//
//  Created by Vladimír Čalfa on 17/04/2018.
//

import Foundation
import FirebaseRemoteConfig

public extension UpdateCenter {
    public convenience init(firebaseConfig: RemoteConfig, delegate: UpdateCenterDelegateProtocol) {
        self.init(dataSource: FirebaseUpdateCenterSource(config: firebaseConfig), delegate: delegate)
    }
}

open class FirebaseUpdateCenterSource: UpdateCenterDataSourceProtocol {
    
    private enum ConfigKey: String {
        case shouldUpdate   = "update_center_should_update"
        case mustUpdate     = "update_center_must_update"
        case latestVersion  = "update_center_latest_version"
    }
    
    private static let UserDefaultsName: String = "update_center"
    private static let UserDefaultsVersionKey: String = "UserDefaultsVersionKey"
    private static let forceUpdateExpirationInterval: TimeInterval = 10.0
    private static let standardUpdateExpirationInterval: TimeInterval = 24*60*60
    
    private static let isDebug = Bundle.main.object(forInfoDictionaryKey: "DEBUG") as! String == "YES"
    
    private var remoteConf: RemoteConfig
    
    public init(config: RemoteConfig) {
        remoteConf = config
        remoteConf.configSettings = RemoteConfigSettings(developerModeEnabled: FirebaseUpdateCenterSource.isDebug)!
        setDefaulValuesFromPlistFile()
    }
    
    private func setDefaulValuesFromPlistFile() {
        if let path = Bundle.updateCenter?.path(forResource: "DefaultValues", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: NSObject] {
            remoteConf.setDefaults(dict)
        }
    }
    
    private var mustUpdateValue: Bool {
        return remoteConf.configValue(forKey: ConfigKey.mustUpdate.rawValue).boolValue
    }
    
    private var shouldUpdateValue: Bool {
        return remoteConf.configValue(forKey: ConfigKey.shouldUpdate.rawValue).boolValue
    }
    
    private var latestVersionValue: String {
        return remoteConf.configValue(forKey: ConfigKey.latestVersion.rawValue).stringValue!
    }
    
    
    /// UpdateCenterDataSourceProtocol
    public func getUpdateValues(callBack: @escaping ((Bool,Bool,SemVersion)->())) {
        
        let expirationInterval = cacheExpirationInterval()
            
        remoteConf.fetch(withExpirationDuration: expirationInterval) { [weak self] (status, error) in
            
            guard let _self = self, error == nil else { return }
            
            switch status {
            case .success:
                _self.remoteConf.activateFetched()
                _self.storeVersion()
                callBack(_self.mustUpdateValue, _self.shouldUpdateValue, SemVersion(_self.latestVersionValue))
                
            case .throttled, .noFetchYet:
                callBack(_self.mustUpdateValue, _self.shouldUpdateValue, SemVersion(_self.latestVersionValue))
            
            case .failure:
                return
            }
        }
    }
    
    open func currentLocalVersion() -> SemVersion? {
        return Bundle.main.semanticVesion
    }
    
    private func cacheExpirationInterval() -> TimeInterval {
        
        let forceRefresh = self.forceRefresh()
        
        print("----: force :--- ---: \(forceRefresh) :---")
        
        return forceRefresh ?  FirebaseUpdateCenterSource.forceUpdateExpirationInterval : FirebaseUpdateCenterSource.standardUpdateExpirationInterval
    }
    
    private func forceRefresh() -> Bool {
        
        guard let defaults = UserDefaults(suiteName: FirebaseUpdateCenterSource.UserDefaultsName) else {
            return true
        }
        
        return !(currentLocalVersion()?.text == defaults.string(forKey: FirebaseUpdateCenterSource.UserDefaultsVersionKey))
    }
    
    private func storeVersion() {
        
        guard let defaults = UserDefaults(suiteName: FirebaseUpdateCenterSource.UserDefaultsName) else {
            return
        }
        
        defaults.setValue(currentLocalVersion()?.text, forKey: FirebaseUpdateCenterSource.UserDefaultsVersionKey)
    }
}

