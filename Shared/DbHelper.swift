//
//  DbHelper.swift
//  DirectStudy
//
//  Created by Justin Fulkerson on 10/24/21.
//

import Foundation
import SQLite3

class DbHelper {
    
    var db: OpaquePointer?
    var path: String = "/Users/justinfulkerson/dev/DirectStudy/Shared/Photos.sqlite"
    init(){
        self.db = createDB()
        
    }
    
    func createDB() -> OpaquePointer?{
        
        
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathExtension(path)
        
        
        var db : OpaquePointer?
        
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return nil
        }
        
        return db
                
            
    }
    
    func select(_ select : String)
    {
        let createTableString = select
        
        var createTableStatement: OpaquePointer?
          // 2
          if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
              SQLITE_OK {
            // 3
            print("\nSUCCESS")
          } else {
            print("\nFAILED.")
          }
    }
    
    func copyDatabaseIfNeeded(_ database: String) {

        let fileManager = FileManager.default

        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

        guard documentsUrl.count != 0 else {
            return
        }

        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("\(database).sqlite")

        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")

            let databaseInMainBundleURL = Bundle.main.resourceURL?.appendingPathComponent("\(database).sqlite")

            do {
                try fileManager.copyItem(atPath: (databaseInMainBundleURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }

        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }
    
}

