//
//  UpdateCenter.swift
//  UpdateCenter
//
//  Created by Vladimír Čalfa on 16/04/2018.
//

import Foundation

public protocol UpdateCenterDelegateProtocol: class {
    
    func notLatestVersion(_ updateCenter: UpdateCenter, latestVersion: SemVersion)
    
    func shouldUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion)
    
    func mustUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion)
    
    func shouldCallShouldUpdate(_ updateCenter: UpdateCenter) -> Bool
    
    func notLatestVersion(_ updateCenter: UpdateCenter) -> Bool
}

public extension UpdateCenterDelegateProtocol {
    
    func notLatestVersion(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {}
    
    func shouldUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {}
    
    func mustUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {}
    
    func shouldCallShouldUpdate(_ updateCenter: UpdateCenter) -> Bool {
        return true
    }
    
    func notLatestVersion(_ updateCenter: UpdateCenter) -> Bool {
        return true
    }
}

final public class UpdateCenter {
    
    private weak var delegate: UpdateCenterDelegateProtocol?
    public let dataSource: UpdateCenterDataSourceProtocol
    
    
    public init (dataSource: UpdateCenterDataSourceProtocol, delegate: UpdateCenterDelegateProtocol) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    public func check() {
        
        dataSource.getUpdateValues { [weak self] (mustUpdate, shouldUpdate, latestVersion) in
            
            guard let _self = self else {
                return
            }
            
            if mustUpdate {
                self?.delegate?.mustUpdate(_self, latestVersion: latestVersion)
                return
            }
            
            if shouldUpdate {
                if _self.delegate?.shouldCallShouldUpdate(_self) ?? true {
                    self?.delegate?.shouldUpdate(_self, latestVersion: latestVersion)
                }
                return
            }
            
            if let current = _self.dataSource.currentLocalVersion(), current < latestVersion {
                if  _self.delegate?.notLatestVersion(_self) ?? true {
                    self?.delegate?.notLatestVersion(_self, latestVersion: latestVersion)
                }
                return
            }
        }
    }
}

public protocol UpdateCenterDataSourceProtocol: class {
    
    typealias UpdateCenterValuesCallback = ((Bool,Bool, SemVersion)->()) // (mustUpdate, shouldUpdate, latestVersion)
    
    func getUpdateValues(callBack: @escaping UpdateCenterValuesCallback)
    
    func currentLocalVersion() -> SemVersion?
}

public extension UpdateCenterDataSourceProtocol {
    func currentLocalVersion() -> SemVersion? {
        return Bundle.main.semanticVesion
    }
}

