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
        var db : OpaquePointer?
        
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return nil
        }
        
        return db
    }
    
    func getPictures() -> Array<String>
    {
        var pictures: [String] = []
        
        let queryString = "select photo_image_url from unsplash_photos"
        
        var statement: OpaquePointer?
        
        if(sqlite3_prepare(db, queryString, -1, &statement, nil)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
        }
        
        var _ = sqlite3_step(statement)
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
                let image_url = String(cString: sqlite3_column_text(statement, 0))
                pictures.append(image_url)
        }
        
        //Check any errors
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("rc = ", sqlite3_step(statement) , "error = ", errmsg)
        }
        
        //cleanup query
        sqlite3_finalize(statement)
        
        return pictures
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

