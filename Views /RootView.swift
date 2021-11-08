//
//  RootView.swift
//  DirectStudy (iOS)
//
//  Created by Justin Fulkerson on 11/7/21.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var authenticator: Authenticator

  var body: some View {
    ContentView()
      .fullScreenCover(isPresented: $authenticator.needsAuthentication) {
        LoginView()
          .environmentObject(authenticator) // see note
      }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
      .environmentObject(Authenticator())
  }
}
