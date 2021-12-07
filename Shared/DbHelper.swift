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
    var path: String = "/Users/justinfulkerson/dev/DirectedStudy/DirectedStudy/Shared/Photos.sqlite"
    init(){
        self.db = createDB()
        
    }
    
    struct pictureObject : Hashable {
        let photo: String
        var rating: Int
        
        init(photo: String, rating: Int){
            self.photo = photo
            self.rating = rating
        }
    }
    
    func createDB() -> OpaquePointer?{
        var db : OpaquePointer?
        
        guard sqlite3_open(path, &db) == SQLITE_OK else {
            print("error opening database Photos DB")
            sqlite3_close(db)
            db = nil
            return nil
        }
        
        return db
    }
    
    func getPictures(usrname: String,isFiltered: Bool) -> Array<pictureObject>
    {
        if(isFiltered == false){
            var pictures: [pictureObject] = []
            
            let queryString = "select photo_image_url from unsplash_photos"
            
            var statement: OpaquePointer?
            
            if(sqlite3_prepare(db, queryString, -1, &statement, nil)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing select: \(errmsg)")
            }
            
            var _ = sqlite3_step(statement)
            
            while(sqlite3_step(statement) == SQLITE_ROW) {
                    let image_url = String(cString: sqlite3_column_text(statement, 0))
                pictures.append(pictureObject(photo: image_url, rating: 0))
                
                
            }
            
            //Check any errors
            if sqlite3_step(statement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("rc = ", sqlite3_step(statement) , "error = ", errmsg)
            }
            
            //cleanup query
            sqlite3_finalize(statement)
            
            //Close DB aftet pictures are returned
            sqlite3_close(db)
            
            return pictures
        }else {
            
            //Array of Strings to return
            var pictures: [pictureObject] = []
            
            //Open User Database to search for interest for a given user
            let userDB = UserDatabase().createDB()
            
            let userSelect = "SELECT interest FROM Interests WHERE UserID_fk IN (SELECT UserID FROM Users WHERE Username =  '" + usrname + "')"
            
            var userStatement : OpaquePointer?
            
            if sqlite3_prepare_v2(userDB, userSelect, -1, &userStatement, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(userDB)!)
                    print("error preparing select: \(errmsg)")
            }
            
            while(sqlite3_step(userStatement) == SQLITE_ROW) {
                let interest = String(cString: sqlite3_column_text(userStatement, 0)).lowercased()
                
                let photosStatementString = "select photo_image_url from unsplash_photos where photo_description like '%" + interest + "%' limit 5"
                
                var photosStatement: OpaquePointer?
                
                if sqlite3_prepare_v2(db, photosStatementString, -1, &photosStatement, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("error preparing select: \(errmsg)")
                }
                
                while(sqlite3_step(photosStatement) == SQLITE_ROW) {
                    let photo = String(cString: sqlite3_column_text(photosStatement, 0))
                    pictures.append(pictureObject(photo: photo, rating: 0))
                }
                
                if sqlite3_step(photosStatement) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("rc = ", sqlite3_step(photosStatement) , "error = ", errmsg)
                }
                
                sqlite3_finalize(photosStatement)
            }
            
            if sqlite3_step(userStatement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("rc = ", sqlite3_step(userStatement) , "error = ", errmsg)
            }
            
            sqlite3_finalize(userStatement)
            
            //Close Photos DB after pictures are returned
            sqlite3_close(db)
            
            //Close User DB after pictures are returned
            sqlite3_close(userDB)
            
            return pictures
        }
    }
}

