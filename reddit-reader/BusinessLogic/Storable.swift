//
//  Storable.swift
//  RedditReader
//
//  Created by Javier Loucim on 24/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

import Foundation

enum StorableError:Error {
    case noFilenameSpecified
    case directoryNotFound
    case dataNotFoundInUserDefaults
}

protocol Storable {
    mutating func initFromData(data:Data) throws
    var storableFileName: String { get }
}

extension Storable where Self: Codable {
    
    func saveToFile() throws {
        guard !storableFileName.isEmpty else { throw StorableError.noFilenameSpecified }
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            try data.write(to: path.appendingPathComponent(storableFileName))
        } else {
            throw StorableError.directoryNotFound
        }
    }
    mutating func readFromFile() throws {
        guard !storableFileName.isEmpty else { throw StorableError.noFilenameSpecified }
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let data = try Data(contentsOf: path.appendingPathComponent(storableFileName))
            try initFromData(data: data)
        } else {
            throw StorableError.directoryNotFound
        }
    }
    
    func saveToUserDefaults(key:String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        UserDefaults.standard.set(data, forKey: key)
    }
    mutating func readFromUserDefaults(key:String) throws {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            try initFromData(data: data)
        } else {
            throw StorableError.dataNotFoundInUserDefaults
        }
    }
}
