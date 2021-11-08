//
//  SignUpView.swift
//  DirectStudy (iOS)
//
//  Created by Justin Fulkerson on 11/7/21.
//

import SwiftUI

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
                            ItemRow("Forest")
                            ItemRow("Plains")
                            ItemRow("Desert")
                            ItemRow("Ocean")
                            ItemRow("City")
                        }.padding(.leading, 20)
                
                        ItemRow("Animals", isCategory: true)
                            Section {
                                ItemRow("Flying Animal")
                                ItemRow("Four Legs")
                                ItemRow("Person")
                                ItemRow("Ocean Animal")
                            }.padding(.leading, 20)
                
                
                    }
            
        }
    
    }
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
