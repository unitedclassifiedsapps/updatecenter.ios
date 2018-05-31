//
//  ViewController.swift
//  UpdateCenter
//
//  Created by Vladimir Calfa on 04/16/2018.
//  Copyright (c) 2018 Vladimir Calfa. All rights reserved.
//

import UIKit
import UpdateCenter
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var currentAppVersionLabel: UILabel!
    @IBOutlet weak var latestVersionLabel: UILabel!
    @IBOutlet weak var updateCallbackFunctionLabel: UILabel!
    @IBOutlet weak var textVersion: UITextField!
    
    private var uc: UpdateCenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uc = UpdateCenter(firebaseConfig: RemoteConfig.remoteConfig(), delegate: self)
        
        uc = UpdateCenter(dataSource: FirebaseUpdateCenterSourceTest(config: RemoteConfig.remoteConfig()), delegate: self)

        
        currentAppVersionLabel.text = uc?.dataSource.currentLocalVersion()?.text
        textVersion.text = uc?.dataSource.currentLocalVersion()?.text
        
        updateCallbackFunctionLabel.text = "------- none ------"
        view.backgroundColor = UIColor.white
        
        uc?.check()
    }
    
    @IBAction func updateCustomVersion(_ sender: UIButton) {
        storeVersion(textVersion.text)
        exit(0)
    }
    
    func storeVersion(_ version: String?) {
        UserDefaults.standard.setValue(version, forKey: "testappversion")
        UserDefaults.standard.synchronize()
    }
}

extension ViewController: UpdateCenterDelegateProtocol {
    
    func notLatestVersion(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        print("----- ++++++++ notLatestVersion ++++++++ ----- (latest: \(latestVersion.text))")
        updateCallbackFunctionLabel.text = "Not latest version"
        latestVersionLabel.text = latestVersion.text
        view.backgroundColor = UIColor.green
    }
    
    func shouldUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        print("----- ++++++++ shouldUpdate ++++++++ ----- (latest: \(latestVersion.text))")
        updateCallbackFunctionLabel.text = "Should update"
        latestVersionLabel.text = latestVersion.text
        view.backgroundColor = UIColor.blue
    }
    
    func mustUpdate(_ updateCenter: UpdateCenter, latestVersion: SemVersion) {
        print("----- ++++++++ mustUpdate ++++++++ ----- (latest: \(latestVersion.text))")
        updateCallbackFunctionLabel.text = "Must update"
        latestVersionLabel.text = latestVersion.text
        view.backgroundColor = UIColor.red
    }
}


class FirebaseUpdateCenterSourceTest: FirebaseUpdateCenterSource {
    
    override func currentLocalVersion() -> SemVersion? {
        
        guard let textVersion = UserDefaults.standard.string(forKey: "testappversion") else {
            return super.currentLocalVersion()
        }
        
        return SemVersion(textVersion)
    }
}
