//
//  RSGlossyQueue.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/20/18.
//

import UIKit
import Gloss
import SecureQueue


public enum RSGlossyQueueError: Error {
    case invalidJSON
}

open class RSGlossyQueue<T: Glossy>: SecureQueue {
    
    public struct RSGlossyQueueElement {
        public let elementId: String
        public let element: T
    }
    
    open func addGlossyElement(element: T) throws {
        
        guard let elementJSON = element.toJSON(),
            JSONSerialization.isValidJSONObject(elementJSON) else {
            throw RSGlossyQueueError.invalidJSON
        }
        
        let jsonData:NSData = try JSONSerialization.data(withJSONObject: elementJSON, options: []) as NSData
        try self.addElement(element: jsonData)

    }
    
    open func removeGlossyElement(element: RSGlossyQueueElement) throws {
        
        try self.removeElement(elementId: element.elementId)
        
    }
    
    private func elementForPair(elementId: String, elementData: NSData) throws -> RSGlossyQueueElement? {
        guard let elementJSON = try JSONSerialization.jsonObject(with: elementData as Data, options: []) as? JSON else {
            return nil
        }
        
        guard let element: T = T.init(json: elementJSON) else {
            return nil
        }
        
        return RSGlossyQueueElement(elementId: elementId, element: element)
    }
    
    open func getGlossyElements() throws -> [RSGlossyQueueElement] {
        
        let elementPairs = try self.getElements()
        
        return try elementPairs.flatMap { pair in
            guard let elementData = pair.1 as? NSData else {
                return nil
            }
            
            return try self.elementForPair(elementId: pair.0, elementData: elementData)
        }
        
    }
    
    open func getInMemoryGlossyElements() throws -> [RSGlossyQueueElement] {
        
        let elementPairs = try self.getInMemoryElements()
        
        return try elementPairs.flatMap { pair in
            guard let elementData = pair.1 as? NSData else {
                return nil
            }
            
            return try self.elementForPair(elementId: pair.0, elementData: elementData)
        }
        
    }
    
    open func getFirstGlossyElement() throws -> RSGlossyQueueElement? {
        guard let elementPair = try self.getFirstElement(),
            let elementData = elementPair.1 as? NSData else {
            return nil
        }
        
        return try self.elementForPair(elementId: elementPair.0, elementData: elementData)
    }
    
    open func getFirstInMemoryGlossyElement() throws -> RSGlossyQueueElement? {
        guard let elementPair = self.getFirstInMemoryElement(),
            let elementData = elementPair.1 as? NSData else {
                return nil
        }
        
        return try self.elementForPair(elementId: elementPair.0, elementData: elementData)
    }

}
