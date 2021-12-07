//
//  UserDatabase.swift
//  DirectStudy
//
//  Created by Justin Fulkerson on 11/27/21.
//

import Foundation
import SQLite3

class UserDatabase{
    
    var db: OpaquePointer?
    var path = "/Users/justinfulkerson/dev/DirectedStudy/DirectedStudy/Shared/Users.sqlite"
    init(){
        self.db = createDB()
        
    }
    
    func createDB() -> OpaquePointer?{
        var db : OpaquePointer?
        
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error opening database users DB")
            sqlite3_close(db)
            db = nil
            return nil
        }
        
        return db
    }
    
    
}
