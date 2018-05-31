//
//  SemVersionTests.swift
//  UpdateCenter_Example
//
//  Created by Vladimír Čalfa on 16/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import UpdateCenter

class SemVersionParseTests: XCTestCase {
    
    
    func testInit() {
        let vetsion = SemVersion(major: 1)
        XCTAssertEqual(vetsion.major, 1)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertNil(vetsion.tag)
    }
    
    func testInit2() {
        let vetsion = SemVersion(major: 1)
        XCTAssertEqual(vetsion.text, "1.0.0")
    }
    
    func testInit3() {
        let vetsion = SemVersion(major: 1)
        XCTAssertNotEqual(vetsion.text, "1")
    }
    
    func testInit4() {
        let vetsion = SemVersion(major: 1, tag: "beta")
        XCTAssertEqual(vetsion.text, "1.0.0-beta")
    }
    
    func testParse0() {

        let vetsion = SemVersion("1")
        
        XCTAssertEqual(vetsion.major, 1)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertNil(vetsion.tag)
    }
    
    func testParse00() {
        
        let vetsion = SemVersion("")
        
        XCTAssertEqual(vetsion.major, 0)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertNil(vetsion.tag)
    }
    
    func testParse() {
        let vetsionString = "1.0.0"
        let vetsion = SemVersion(vetsionString)
        
        XCTAssertEqual(vetsion.major, 1)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertNil(vetsion.tag)
    }
    
    func testParse1() {
        let vetsionString = "1.0.0-RC1"
        let vetsion = SemVersion(vetsionString)
        
        XCTAssertEqual(vetsion.major, 1)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertEqual(vetsion.tag, "RC1")
    }
    
    func testParse3() {
        let vetsionString = "1.0.0-RC1-12"
        let vetsion = SemVersion(vetsionString)
        
        XCTAssertEqual(vetsion.major, 1)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertEqual(vetsion.tag, "RC1-12")
    }
    
    func testParse4() {
        let vetsionString = "1.0-RC1-12"
        let vetsion = SemVersion(vetsionString)
        
        XCTAssertEqual(vetsion.major, 1)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertEqual(vetsion.tag, "RC1-12")
    }
    
    func testParse5() {
        let vetsionString = "1-RC1"
        let vetsion = SemVersion(vetsionString)
        
        XCTAssertEqual(vetsion.major, 1)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertEqual(vetsion.tag, "RC1")
    }
    
    func testParse6() {
        let vetsionString = "alfa"
        let vetsion = SemVersion(vetsionString)
        
        XCTAssertEqual(vetsion.major, 0)
        XCTAssertEqual(vetsion.minor, 0)
        XCTAssertEqual(vetsion.patch, 0)
        XCTAssertNil(vetsion.tag)
    }
}
