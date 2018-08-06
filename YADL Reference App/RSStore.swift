//
//  RSStore.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 11/6/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchSuiteAppFramework
import ResearchSuiteExtensions
import ResearchSuiteTaskBuilder
import LS2SDK

class RSStore: NSObject, RSTBStateHelper {
    
    let store = RSKeychainCredentialsStore(namespace: "appStore")
    
    func objectInState(forKey: String) -> AnyObject? {
        return nil
    }
    
    
    func valueInState(forKey: String) -> NSSecureCoding? {
        return self.get(key: forKey)
    }
    
    func setValueInState(value: NSSecureCoding?, forKey: String) {
        self.set(value: value, key: forKey)
    }
    
    func set(value: NSSecureCoding?, key: String) {
        store.setValueInState(value: value, forKey: key)
    }
    func get(key: String) -> NSSecureCoding? {
        return store.valueInState(forKey: key)
    }

//
//    func reset() {
//        store
//    }
//
}
