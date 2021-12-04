//
//  ContentView.swift
//  Shared
//
//  Created by Justin Fulkerson on 10/24/21.
//

import SwiftUI
import StarRating
import SQLite3


func insertRating(rating: Double,usrname: String,picture: String) {
    //Open up Users database
    let userDB = UserDatabase().createDB()
    
    print(rating,usrname,picture)
    
    
    let insertStatementString = "insert into Rating (Picture,Rating,UserID_fk) values('" + picture + "','" + String(rating)  + "',(select UserID from Users where Username = '" + usrname + "'))"
    
    var insertStatement: OpaquePointer?
    
    if sqlite3_prepare_v2(userDB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
        
        if sqlite3_step(insertStatement) == SQLITE_DONE {
            print("Inserted Row")
        } else{
            print("Could not insert row")
        }
        
    } else {
        print("Insert statement not prepared")
    }
        sqlite3_finalize(insertStatement)
    
        sqlite3_close(userDB)
}



struct ContentView: View {
    
    @EnvironmentObject var authenticator: Authenticator
    
    @State private var rating: Int = 0
    
    @EnvironmentObject var model: GlobalModel
    
    @State private var filtered: Bool = false
    
    var body: some View {
        
        Button("Filter Pictures"){
            filtered = true
        }
        
        //Open Database normally
        var pictureURL = DbHelper().getPictures(usrname: model.usrName, isFiltered: filtered)
        
        List(pictureURL, id: \.self) { pic in
            //For each photo in pictureURL
                //Associate with a rating clikced on by the user
            
            VStack{
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: pic.photo), scale: 10.0)
                } else {
                    // Fallback on earlier versions
                }
                StarRating(initialRating: 0,onRatingChanged: {
                    insertRating(rating: $0, usrname: model.usrName, picture: pic.photo)
                    
                })
            }
        }
        Button("Logout") {
            authenticator.logout()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Authenticator())
            .environmentObject(GlobalModel())
    }
}
