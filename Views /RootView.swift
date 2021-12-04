//
//  RootView.swift
//  DirectStudy (iOS)
//
//  Created by Justin Fulkerson on 11/7/21.
//

import SwiftUI

class GlobalModel: ObservableObject {
    @Published var usrName = ""
    
    
}
struct RootView: View {
  @EnvironmentObject var authenticator: Authenticator
    
  @StateObject var globalModel = GlobalModel()
    
    
  var body: some View {
      ContentView()
          .environmentObject(globalModel)
      .fullScreenCover(isPresented: $authenticator.needsAuthentication) {
        LoginView()
          .environmentObject(authenticator)
          .environmentObject(globalModel)// see note
      }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
      .environmentObject(Authenticator())
      .environmentObject(GlobalModel())
  }
}
