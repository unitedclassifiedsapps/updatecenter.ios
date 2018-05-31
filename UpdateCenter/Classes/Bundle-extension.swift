//
//  Bundle-extension.swift
//  UpdateCenter
//
//  Created by Vladimír Čalfa on 17/04/2018.
//

import Foundation

extension Bundle {
    
    var semanticVesion: SemVersion? {
        guard let version = version else {
                return nil
        }
        return SemVersion(version)
    }
    
    var version: String? {
        guard let infoDictionary = self.infoDictionary,
            let version = infoDictionary["CFBundleShortVersionString"] as? String else {
                return nil
        }
        return version
    }
    
    static var updateCenter: Bundle? {
        let bundle = Bundle(for: UpdateCenter.self)
        guard let path = bundle.path(forResource: "UpdateCenter", ofType: "bundle") else {
                return nil
        }
        return Bundle(path: path)
    }
}
