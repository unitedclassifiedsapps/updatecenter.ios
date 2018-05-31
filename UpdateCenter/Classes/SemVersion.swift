//
//  SemVersion.swift
//  UpdateCenter
//
//  Created by Vladimír Čalfa on 16/04/2018.
//

import Foundation

public struct SemVersion {
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let tag: String?
    
    public init(_ version: String) {
        
        let versionParts = version.split(separator: "-", maxSplits: 1)
        
        tag = versionParts.count > 1 ? String(versionParts[1])  : nil
        
        let numberParts = versionParts.first
        let parts = numberParts?.split(separator: ".") ?? [Substring]()
        
        major = parts.count > 0 ? ( Int(parts[0]) ?? 0 ) : 0
        minor = parts.count > 1 ? ( Int(parts[1]) ?? 0 ) : 0
        patch = parts.count > 2 ? ( Int(parts[2]) ?? 0 ) : 0
    }
    
    public init(major: Int = 0, minor: Int = 0, patch: Int = 0, tag: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.tag = tag
    }
    
    public var text: String {
        guard let tag = tag else {
            return "\(major).\(minor).\(patch)"
        }
        return "\(major).\(minor).\(patch)-\(tag)"
    }
}

private let compareLocale = Locale(identifier: "US-en")

extension SemVersion: Comparable {
    //Comparable
    public static func < (lhs: SemVersion, rhs: SemVersion) -> Bool {
        return (lhs.major < rhs.major) ||
            (lhs.major == rhs.major && lhs.minor < rhs.minor) ||
            (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch < rhs.patch) ||
            (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch && lhs.tag != nil && rhs.tag == nil) ||
            (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch && lhs.tag != nil && rhs.tag != nil && (lhs.tag!.compare(rhs.tag!, locale: compareLocale) == .orderedAscending))
    }
    
    public static func <= (lhs: SemVersion, rhs: SemVersion) -> Bool {
        return !( lhs > rhs )
    }
    
    public static func > (lhs: SemVersion, rhs: SemVersion) -> Bool {
        return (lhs.major > rhs.major) ||
            (lhs.major == rhs.major && lhs.minor > rhs.minor) ||
            (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch > rhs.patch) ||
            (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch && lhs.tag == nil && rhs.tag != nil) ||
            (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch && lhs.tag != nil && rhs.tag != nil && (lhs.tag!.compare(rhs.tag!, locale: compareLocale) == .orderedDescending))
    }
    
    public static func >= (lhs: SemVersion, rhs: SemVersion) -> Bool {
        return !( lhs < rhs )
    }
}

extension SemVersion: Equatable {
    //Equatable
    public static func == (lhs: SemVersion, rhs: SemVersion) -> Bool {
        return lhs.major == rhs.major &&
            lhs.minor == rhs.minor &&
            lhs.patch == rhs.patch &&
            lhs.tag == rhs.tag
    }
}
