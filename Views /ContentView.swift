//
//  ContentView.swift
//  Shared
//
//  Created by Justin Fulkerson on 10/24/21.
//

import SwiftUI

struct ContentView: View {
    
    var pictureURL = DbHelper().getPictures()
    @EnvironmentObject var authenticator: Authenticator
    
    var body: some View {
        List(pictureURL, id: \.self) { photo in
            VStack{
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: photo), scale: 10.0)
                } else {
                    // Fallback on earlier versions
                }
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
    }
}
