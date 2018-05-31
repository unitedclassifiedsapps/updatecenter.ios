//
//  UpdateCenterControl.swift
//  UpdateCenter
//
//  Created by Vladimír Čalfa on 19/04/2018.
//

import Foundation

open class UpdateCenterControl: UpdateCenterDelegateProtocol {

    private static let userDefaultsName = "UpdateCenterUserDefault"
    private enum UserDefaultKeys: String {
        case shouldUpdateMinSilentInterval = "shouldUpdateMinSilentInterval"
        case notLatestVersionMinSilentInterval = "notLatestVersionMinSilentInterval"
    }
    
    public let shouldUpdateMinSilentInterval: TimeInterval?
    public let notLatestVersionMinSilentInterval: TimeInterval?
    
    private weak var delegate: UpdateCenterDelegateProtocol?
    
    private var store: UserDefaults? {
        return UserDefaults(suiteName: UpdateCenterControl.userDefaultsName)
    }
    
    public init(delegate: UpdateCenterDelegateProtocol, shouldUpdateSilent: TimeInterval? = nil, notLatestVersionSilent: TimeInterval? = nil) {
        self.delegate = delegate
        shouldUpdateMinSilentInterval = shouldUpdateSilent
        notLatestVersionMinSilentInterval = notLatestVersionSilent
    }
    
    public func notLatestVersion(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        delegate?.notLatestVersion(updateCenter, latestVersion: latestVersion)
    }

    public func shouldUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        delegate?.shouldUpdate(updateCenter, latestVersion: latestVersion)
    }

    public func mustUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        delegate?.mustUpdate(updateCenter, latestVersion: latestVersion)
    }

    public func shouldCallShouldUpdate(_ updateCenter: UpdateCenter) -> Bool {
        return checkMinSilentInterval(key: UserDefaultKeys.shouldUpdateMinSilentInterval.rawValue,
                                      minInterval: shouldUpdateMinSilentInterval,
                                      at: Date().timeIntervalSince1970)
    }
    
    public func notLatestVersion(_ updateCenter: UpdateCenter) -> Bool {
        return checkMinSilentInterval(key: UserDefaultKeys.notLatestVersionMinSilentInterval.rawValue,
                                      minInterval: notLatestVersionMinSilentInterval,
                                      at: Date().timeIntervalSince1970)
    }
    
    private func checkMinSilentInterval(key: String, minInterval: TimeInterval?, at date: TimeInterval) -> Bool {
        
        guard let defaults = store, let minInterval = minInterval else { // store unavailable -> tehn call
            return true
        }

        let lastCalled = defaults.double(forKey: key)

        if lastCalled == 0.0 || date - lastCalled > minInterval { // notCalledYet ,.....
            defaults.set(date, forKey: key)
            return true
        }
        
        return false
    }
    
    public func reset() {
        store?.set(nil, forKey: UserDefaultKeys.shouldUpdateMinSilentInterval.rawValue)
        store?.set(nil, forKey: UserDefaultKeys.notLatestVersionMinSilentInterval.rawValue)
        store?.synchronize()
    }
}
