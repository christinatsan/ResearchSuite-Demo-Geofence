//
//  RSLogger.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 5/9/18.
//

import UIKit

public enum RSLogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warn = "WARN"
    case error = "ERROR"
    case fatal = "FATAL"
}

public protocol RSLogger {
    func log(tag: String, level: RSLogLevel, message: String)
}

public class RSFileLogger: NSObject, RSLogger {

    let logQueue: DispatchQueue
    public let logDirectory: URL
    public let logFile: URL
    
    public init?(directory: String) {
        
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
            return nil
        }
        
        self.logQueue = DispatchQueue(label: "RSLogger.dispatchQueue.\(directory)")
        
        let finalDirectory = documentsPath.appending("/\(directory)")
        var isDirectory : ObjCBool = false
        if FileManager.default.fileExists(atPath: finalDirectory, isDirectory: &isDirectory) {
            
            //if a file, remove file and add directory
            if isDirectory.boolValue {
                
            }
            else {
                
                do {
                    try FileManager.default.removeItem(atPath: finalDirectory)
                } catch let error as NSError {
                    //TODO: handle this
                    print(error.localizedDescription);
                }
            }
            
        }
        
        do {
            
            try FileManager.default.createDirectory(atPath: finalDirectory, withIntermediateDirectories: true, attributes: [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication])
            var url: URL = URL(fileURLWithPath: finalDirectory)
            var resourceValues: URLResourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)
            
        } catch let error as NSError {
            //TODO: Handle this
            print(error.localizedDescription);
        }
        
        self.logDirectory = URL(string: finalDirectory)!
        let fileDateString = RSFileLogger.string(for: Date())
        let finalLogFilePath = finalDirectory.appending("/\(fileDateString).log")
        self.logFile = URL(fileURLWithPath: finalLogFilePath)
    }
    
    public func log(tag: String, level: RSLogLevel, message: String) {
        let fullString = RSFileLogger.generateFullString(tag: tag, level: level, message: message)
        
        self.logQueue.sync {
            
            if let outputStream = OutputStream(url: self.logFile, append: true),
                let data = fullString.data(using: .utf8) {
                outputStream.open()

                let bytesWritten = data.withUnsafeBytes({ outputStream.write($0, maxLength: data.count) })
                if bytesWritten < 0 { print("write failure") }
                outputStream.close()
            } else {
                print("Unable to open file")
            }
        }
    }
    
    static func string(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateFormatter.string(from: date)
    }
    
    
    static func generateFullString(tag: String, level: RSLogLevel, message: String) -> String {
        let dateString: String = RSFileLogger.string(for: Date())
        return "\(dateString): \(level.rawValue): \(tag) - \(message)\n"
    }
    
    
}
