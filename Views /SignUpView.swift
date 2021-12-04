//
//  SignUpView.swift
//  DirectStudy (iOS)
//
//  Created by Justin Fulkerson on 11/7/21.
//

import SwiftUI
import SQLite3

@available(iOS 15.0, *)
struct SignUpView: View {
    
    struct ItemRow: View {
        let category: Bool
        let text: String

        init(_ text: String, isCategory: Bool = false) {
            self.category = isCategory
            self.text = text
        }

        var body: some View {
            HStack {
                Circle().stroke() // this can be custom control
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        // handle tap here
                    }
                if category {
                    Text(self.text).bold()
                } else {
                    Text(self.text)
                }
            }
        }
    }

    
    
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack{
            TextField ("User Name (Email)",
                text: $username
            )
            
            TextField ("Password",
                text: $password
            )
            
            
            List { // next pattern easily wrapped with ForEach
                        ItemRow("Nature", isCategory: true) // this can be section's header
                        Section {
                            Button(action: {
                                handleInterest(theme:"Forest",usrname: username)
                        }) {
                            Text("Forest")
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0)
                                        .shadow(color: .blue, radius: 10.0)
                                )
                        }
                            Button(action: {
                                handleInterest(theme:"Plains",usrname: username)
                        }) {
                            Text("Plains")
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0)
                                        .shadow(color: .blue, radius: 10.0)
                                )
                        }
                            Button(action: {
                                handleInterest(theme:"Desert",usrname: username)
                        }) {
                            Text("Desert")
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0)
                                        .shadow(color: .blue, radius: 10.0)
                                )
                        }
                            Button(action: {
                                handleInterest(theme:"Ocean",usrname: username)
                        }) {
                            Text("Ocean")
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0)
                                        .shadow(color: .blue, radius: 10.0)
                                )
                        }
                            Button(action: {
                                handleInterest(theme:"City",usrname: username)
                        }) {
                            Text("City")
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0)
                                        .shadow(color: .blue, radius: 10.0)
                                )
                        }
                        }.padding(.leading, 20)
                
                    }
            Button(action: {
                handleSubmit(usrname: username, pass: password)
        }) {
            Text("Submit")
                .padding(10.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .shadow(color: .blue, radius: 10.0)
                )
        }
            
        }
    
    }
}

func handleInterest(theme: String,usrname: String)
{
    //open database
    let userDB = UserDatabase().createDB()
    
    let queryStatementString = "insert into Interests (interest,UserID_fk) values('" + theme + "'," + "(select UserID from Users where Username = '" + usrname + "'))"
    
    var queryStatement: OpaquePointer?
    
    if sqlite3_prepare_v2(userDB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        
        if sqlite3_step(queryStatement) == SQLITE_DONE {
            print("Inserted Row")
        } else{
            print("Could not insert row")
        }
        
    } else {
        print("Insert statement not prepared")
    }
        sqlite3_finalize(queryStatement)
    
    sqlite3_close(userDB)
}

func doesExist(db: OpaquePointer?,passwd:String,username:String) -> Bool
{
    let queryStatementString = "select Passwd, Username from Users where Passwd = '" + passwd + "'" + " and " + "Username = '" + username + "'"
    
    var queryStatement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        return true
    }else {
        return false
    }
    
}

func handleSubmit(usrname:String,pass:String)
{
    //open database
    let userDB = UserDatabase().createDB()
    

    
        //Combination not in database, now insert values
        let insertStatementString = "insert into Users (Passwd, Username) values (?,?);"
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(userDB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)
            
            sqlite3_bind_text(insertStatement, 1, pass, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 2, usrname, -1, SQLITE_TRANSIENT)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Inserted Row")
            } else{
                print("Could not insert row")
            }

        }else {
            print("Insert statement not prepared")
        }
        sqlite3_finalize(insertStatement)
        //close database
        sqlite3_close(userDB)
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            SignUpView()
        } else {
            // Fallback on earlier versions
        }
    }
}
