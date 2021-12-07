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
    let userDBObject = UserDatabase();
    
    let userDB = userDBObject.createDB()
    
    print(rating,usrname,picture)
    
    
    let insertStatementString = "insert into Rating (Picture,Rating,UserID_fk) values('" + picture + "','" + String(rating)  + "',(select UserID from Users where Username = '" + usrname + "'))"
    
    var insertStatement: OpaquePointer? = nil
    
    if sqlite3_prepare_v2(userDB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
        if sqlite3_step(insertStatement) == SQLITE_DONE{
            print("Inserted Row")
        } else{
            print(sqlite3_errmsg(insertStatement))
            print("Could not insert row")
        }
        
    }
    
    do { sqlite3_finalize(insertStatement) }
    
    print(userDBObject.UserDBCounter)
    userDBObject.close()
}


struct ContentView: View {
    
    @EnvironmentObject var authenticator: Authenticator
    
    @State private var rating: Int = 0
    
    @EnvironmentObject var model: GlobalModel

    @State private var filtered: Bool = false
    
    @State private var inputToModel = [String : Double]()
    
    
    @State private var recommendedPictures : [String] = []
    @State private var  showRecommendedPictures : Bool = false
    
    
    
    
    var body: some View {
        
        
        
        Button("Filter Pictures"){
            filtered = true
        }
        
        Button("Show Recommended Pictures"){
            
            showRecommendedPictures = true
            
            
            //Get picture/rating input from Ratings Table for a given user
            
            //Open Database
            let userDBObject = UserDatabase()
            
            let userDB = userDBObject.createDB()
            
            let queryStatementString = "SELECT Picture,Rating FROM rating WHERE UserID_fk IN (SELECT UserID from Users WHERE Username = '" + model.usrName + "' )"
            
            var queryStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(userDB, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    guard let queryResultCol1 = sqlite3_column_text(queryStatement, 0) else {
                            print("Query result is nil")
                            return
                          }
                    guard let queryResultCol2 = sqlite3_column_text(queryStatement, 1) else {
                            print("Query result is nil")
                            return
                          }
                    
                    let pic = String(cString: queryResultCol1)
                    let rating = String(cString: queryResultCol2)
                    
                    inputToModel[pic] = Double(rating)
                }
            }
            
            
            //Give input input into model with hashmap values
            let input = PicRecommenderInput(items: inputToModel, k: 5)
            
            //Predict based on the input
            guard let result = try? PicRecommender().prediction(input: input) else {
                fatalError("Could not get results back")
            }
            
            //Get the pictures from the result
            let results = result.scores
            
            for (key,_) in results {
                let pic = String( key.dropLast().dropLast().dropFirst().dropFirst().dropLast())
                print(pic)
                recommendedPictures.append(pic)
            }
            
            sqlite3_finalize(queryStatement)
            
            userDBObject.close()
        }
        
        //Open Database normally
        let pictureURL = DbHelper().getPictures(usrname: model.usrName, isFiltered: filtered)
        
        if(showRecommendedPictures == true){
            NavigationView{
                List(recommendedPictures, id: \.self){ pic in
                    LazyVStack {
                        if #available(iOS 15.0, *) {
                            AsyncImage(url: URL(string: pic), scale: 15.0)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }.navigationBarTitle("Recommended Pictures")
                    .navigationBarHidden(false)
                    .navigationBarItems(leading: Button(action: {showRecommendedPictures = false}){
                        Image(systemName: "arrow.left")
                        Text("Back")
                    })
            }
        }
        
        List(pictureURL, id: \.self) { pic in
            //For each photo in pictureURL
                //Associate with a rating clikced on by the user
            
            LazyVStack{
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
