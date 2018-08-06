//
//  RSKeychainHelper.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/25/18.
//

import UIKit
import ResearchKit

open class RSKeychainHelper: NSObject {
    
    static private let keychainQueue = DispatchQueue(label: "keychainQueue")
    
    class open func setKeychainObject(_ object: NSSecureCoding, forKey key: String) {
        do {
            try keychainQueue.sync {
                try ORKKeychainWrapper.setObject(object, forKey: key)
            }
        } catch let error {
            assertionFailure("Got error \(error) when setting \(key)")
        }
    }
    
    class open func removeKeychainObject(forKey key: String) {
        do {
            try keychainQueue.sync {
                try ORKKeychainWrapper.removeObject(forKey: key)
            }
        } catch let error {
            assertionFailure("Got error \(error) when setting \(key)")
        }
    }
    
    class open func clearKeychain() {
        do {
            try keychainQueue.sync {
                try ORKKeychainWrapper.resetKeychain()
            }
        } catch let error as NSError {
            //TODO: handle this error?
//            print(error.localizedDescription)
        }
    }
    
    class open func getKeychainObject(_ key: String) -> NSSecureCoding? {
        
        return keychainQueue.sync {
            var error: NSError?
            let o = ORKKeychainWrapper.object(forKey: key, error: &error)
            if error == nil {
                return o
            }
            else {
//                print("Got error \(error) when getting \(key). This may just be the key has not yet been set!!")
                return nil
            }
        }
        
    }
    
}
