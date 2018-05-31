//
//  UpdateCenterTests.swift
//  UpdateCenter_Example
//
//  Created by Vladimír Čalfa on 17/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import UpdateCenter

class TestUpdateCenterDataSource: UpdateCenterDataSourceProtocol {
    
    private let localVersion: SemVersion
    private let mustUpdate: Bool
    private let shouldUpdate: Bool
    private let latestVersion: SemVersion
    
    init(localVersion: SemVersion, mustUpdate: Bool, shouldUpdate: Bool, latestVersion: SemVersion) {
        self.localVersion = localVersion
        self.mustUpdate = mustUpdate
        self.shouldUpdate = shouldUpdate
        self.latestVersion = latestVersion
    }
    
    func getUpdateValues(callBack: @escaping UpdateCenterValuesCallback) { //(mustUpdate, shouldUpdate, latestVersion)
        callBack(mustUpdate,shouldUpdate,latestVersion)
    }
    
    func currentLocalVersion() -> SemVersion? {
        return localVersion
    }
}

class TestUpdateCenterDelegateEmpty: UpdateCenterDelegateProtocol {
}

class TestUpdateCenterDelegate: UpdateCenterDelegateProtocol {
    
    private(set) var notLatestVersionCall: Int = 0
    private(set) var shouldUpdateCall: Int = 0
    private(set) var mustUpdateCall: Int = 0

    func notLatestVersion(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        notLatestVersionCall = notLatestVersionCall + 1
    }
    
    func shouldUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        shouldUpdateCall = shouldUpdateCall + 1
    }
    
    func mustUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        mustUpdateCall = mustUpdateCall + 1
    }
}


class UpdateCenterTests: XCTestCase {
    
    func testVersion() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.1.0"), mustUpdate: false, shouldUpdate: false, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
        
        XCTAssertEqual(delegate.notLatestVersionCall, 0)
        XCTAssertEqual(delegate.shouldUpdateCall, 0)
        XCTAssertEqual(delegate.mustUpdateCall, 0)
    }
    
    func testVersion2() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: false, shouldUpdate: false, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
        
        XCTAssertEqual(delegate.notLatestVersionCall, 1)
        XCTAssertEqual(delegate.shouldUpdateCall, 0)
        XCTAssertEqual(delegate.mustUpdateCall, 0)
    }
    
    func testVersion3() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: false, shouldUpdate: false, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
        XCTAssertEqual(delegate.notLatestVersionCall, 1)
        XCTAssertEqual(delegate.shouldUpdateCall, 0)
        XCTAssertEqual(delegate.mustUpdateCall, 0)
    }
    
    func testVersion4() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: false, shouldUpdate: true, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
        XCTAssertEqual(delegate.notLatestVersionCall, 0)
        XCTAssertEqual(delegate.shouldUpdateCall, 1)
        XCTAssertEqual(delegate.mustUpdateCall, 0)
    }
    
    func testVersion5() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: true, shouldUpdate: true, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
        XCTAssertEqual(delegate.notLatestVersionCall, 0)
        XCTAssertEqual(delegate.shouldUpdateCall, 0)
        XCTAssertEqual(delegate.mustUpdateCall, 1)
    }
    
    func testVersion6() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: true, shouldUpdate: true, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
        uc.check()
        XCTAssertEqual(delegate.notLatestVersionCall, 0)
        XCTAssertEqual(delegate.shouldUpdateCall, 0)
        XCTAssertEqual(delegate.mustUpdateCall, 2)
    }
    
    func testVersion7() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: true, shouldUpdate: true, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let updateControldelegate = UpdateCenterControl(delegate: delegate, shouldUpdateSilent: 1, notLatestVersionSilent: 1)
        updateControldelegate.reset()
        let uc = UpdateCenter(dataSource: dataSource, delegate: updateControldelegate)
        uc.check()
        uc.check()
        XCTAssertEqual(delegate.notLatestVersionCall, 0)
        XCTAssertEqual(delegate.shouldUpdateCall, 0)
        XCTAssertEqual(delegate.mustUpdateCall, 2)
    }
    
    func testVersion8() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: false, shouldUpdate: true, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let updateControldelegate = UpdateCenterControl(delegate: delegate, shouldUpdateSilent: 1, notLatestVersionSilent: 1)
        updateControldelegate.reset()
        let uc = UpdateCenter(dataSource: dataSource, delegate: updateControldelegate)
        uc.check()
        uc.check()
        XCTAssertEqual(delegate.notLatestVersionCall, 0)
        XCTAssertEqual(delegate.shouldUpdateCall, 1)
        XCTAssertEqual(delegate.mustUpdateCall, 0)
    }
    
    func testVersion9() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: false, shouldUpdate: false, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegate()
        let updateControldelegate = UpdateCenterControl(delegate: delegate, shouldUpdateSilent: 1, notLatestVersionSilent: 1)
        updateControldelegate.reset()
        let uc = UpdateCenter(dataSource: dataSource, delegate: updateControldelegate)
        uc.check()
        uc.check()
        XCTAssertEqual(delegate.notLatestVersionCall, 1)
        XCTAssertEqual(delegate.shouldUpdateCall, 0)
        XCTAssertEqual(delegate.mustUpdateCall, 0)
    }
    
    func testVersion10() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: false, shouldUpdate: false, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegateEmpty()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
    }
    
    func testVersion11() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: false, shouldUpdate: true, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegateEmpty()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
    }
    
    func testVersion12() {
        let dataSource = TestUpdateCenterDataSource(localVersion: SemVersion("1.0.0"), mustUpdate: true, shouldUpdate: false, latestVersion: SemVersion("1.1.0"))
        let delegate = TestUpdateCenterDelegateEmpty()
        let uc = UpdateCenter(dataSource: dataSource, delegate: delegate)
        uc.check()
    }
}
