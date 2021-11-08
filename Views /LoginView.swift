//
//  LoginView.swift
//  DirectStudy (iOS)
//
//  Created by Justin Fulkerson on 11/7/21.
//


import SwiftUI

struct LoginView: View {
  @EnvironmentObject var authenticator: Authenticator

  @State private var userName: String = ""
  @State private var password: String = ""

  var body: some View {
    ZStack {
      Color.yellow
        .ignoresSafeArea(.all)
      VStack {
        Text("Please log in")
          .font(.title2)
        TextField("User name", text: $userName)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)
          .disableAutocorrection(true)
        SecureField("Password", text: $password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Button(authenticator.isAuthenticating ? "Please wait" : "Log in"
) {
          authenticator.login(username: userName, password: password)
        }
        .disabled(isLoginDisabled)
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .opacity(authenticator.isAuthenticating ? 1.0 : 0.0)
          
          NavigationView{
              VStack{
                  Text("Don't Have an Account? Click Below")
                  if #available(iOS 15.0, *) {
                      NavigationLink(destination: SignUpView()){
                          Text("Sign Up")
                      }
                  } else {
                      // Fallback on earlier versions
                  }
              }
          }
          
      }
      .frame(maxWidth: 320)
      .padding(.horizontal)
    }
  }

  private var isLoginDisabled: Bool {
    authenticator.isAuthenticating || userName.isEmpty || password.isEmpty
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
      .environmentObject(Authenticator())
  }
}
