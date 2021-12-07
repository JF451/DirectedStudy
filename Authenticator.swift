//
//  Authenticator.swift
//  DirectStudy (iOS)
//
//  Created by Justin Fulkerson on 11/7/21.
//

import Foundation
import SQLite3

class Authenticator: ObservableObject {
  @Published var needsAuthentication: Bool
  @Published var isAuthenticating: Bool

  init() {
    self.needsAuthentication = true
    self.isAuthenticating = false
  }
    
    func checkUser(db: OpaquePointer?,un: String,pw: String) -> Bool
    {
        
        let queryStatementString = "select Passwd, Username from Users where Passwd = '" + pw + "'" + " and " + "Username = '" + un + "'"
        
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = sqlite3_column_text(queryStatement, 1)
                print(name as Any)
            }
            return true
        }else {
            return false
        }
        
    }

  func login(username: String, password: String) {
      
    self.isAuthenticating = true
      
      let userDBObject = UserDatabase()
      
      //Open database for validation
      let userDB = userDBObject.createDB()
      
      
      //Open Database for filtering
      //let photoDB = DbHelper().getPictures(usrName: username)

            self.isAuthenticating = false
            self.needsAuthentication = false
      
      print(userDBObject.UserDBCounter)
      userDBObject.close()
  }

  func logout() {
    self.needsAuthentication = true
  }
}
