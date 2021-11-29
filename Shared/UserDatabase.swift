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
    var path = "/Users/justinfulkerson/dev/DirectStudy/Shared/Users.sqlite"
    init(){
        self.db = createDB()
        
    }
    
    func createDB() -> OpaquePointer?{
        var db : OpaquePointer?
        
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return nil
        }
        
        return db
    }
    
    func test() {
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "select UserID, Passwd from Users", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            let UserID = sqlite3_column_int64(statement, 0)
            print("id = \(UserID); ", terminator: "")

            if let cString = sqlite3_column_text(statement, 1) {
                let Passwd = String(cString: cString)
                print("Passwd = \(Passwd)")
            } else {
                print("name not found")
            }
        }

        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }

        statement = nil
    }
    
    
}
