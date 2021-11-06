//
//  ContentView.swift
//  Shared
//
//  Created by Justin Fulkerson on 10/24/21.
//

import SwiftUI

struct ContentView: View {
    
    var db = DbHelper().select("select * from unsplash_photos limit 3")
    
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
