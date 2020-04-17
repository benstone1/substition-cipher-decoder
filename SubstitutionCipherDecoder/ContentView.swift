//
//  ContentView.swift
//  SubstitutionCipherDecoder
//
//  Created by Benjamin Stone on 3/25/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var encodedStr = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Panda Decoder")
                .font(.largeTitle)
            Spacer()
            HStack(alignment: .center) {
                Text("Enter a word to decode:")
                    .font(.callout)
                    .bold()
                TextField("", text: $encodedStr)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding()
            Button(action: { print("Button pressed") }) {
                Text("Decode")
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
