//
//  SemVersionCompareTests.swift
//  UpdateCenter_Example
//
//  Created by Vladimír Čalfa on 17/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

import XCTest
import UpdateCenter

class SemVersionCompareTests: XCTestCase {
    
    func testCompare1() {
        let vetsionStringLeft = "1.1.0"
        let vetsionStringRight = "1.100.0"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft < vetsionRight, true)
    }
    
    func testCompare2() {
        let vetsionStringLeft = "1.1.0-RC1"
        let vetsionStringRight = "1.1.0-RC2"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft < vetsionRight, true)
    }
    
    func testCompare3() {
        let vetsionStringLeft = "1.1.0-RC1"
        let vetsionStringRight = "1.1.0-RC1"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft < vetsionRight, false)
    }
    
    func testCompare4() {
        let vetsionStringLeft = "1.1.0-alpha"
        let vetsionStringRight = "1.1.0-RC1"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        
        XCTAssertEqual(vetsionLeft.tag, "alpha")
        XCTAssertEqual(vetsionRight.tag, "RC1")
        
        XCTAssertEqual(vetsionLeft < vetsionRight, true)
    }
    
    func testCompare5() {
        let vetsionStringLeft = "1.1.0-RC1"
        let vetsionStringRight = "1.1.0-alpha"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft > vetsionRight, true)
    }
    
    func testCompareEqual() {
        let vetsionStringLeft = "1.1.0-alpha"
        let vetsionStringRight = "1.1.0-alpha"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft == vetsionRight, true)
    }
    
    func testCompareNotEqual() {
        let vetsionStringLeft = "1.1.0-alpha1"
        let vetsionStringRight = "1.1.0-alpha"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft == vetsionRight, false)
    }
    
    func testComparGreatOrEqual() {
        let vetsionStringLeft = "1.1.0-alpha"
        let vetsionStringRight = "1.1.0-alpha"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft >= vetsionRight, true)
    }
    
    func testComparGreatOrEqual2() {
        let vetsionStringLeft = "1.1.0-alpha"
        let vetsionStringRight = "1.1.0-beta"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft >= vetsionRight, false)
    }
    
    func testComparSmallOrEqual() {
        let vetsionStringLeft = "1.1.0-alpha"
        let vetsionStringRight = "1.1.0-alpha"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft <= vetsionRight, true)
    }
    
    func testComparSmallOrEqual2() {
        let vetsionStringLeft = "1.1.0-beta"
        let vetsionStringRight = "1.1.0-alpha"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft <= vetsionRight, false)
    }
    
    func testCompar8() {
        let vetsionStringLeft = "1.1.0"
        let vetsionStringRight = "1.1.0-alpha"
        let vetsionLeft = SemVersion(vetsionStringLeft)
        let vetsionRight = SemVersion(vetsionStringRight)
        
        XCTAssertEqual(vetsionLeft > vetsionRight, true)
    }
}
