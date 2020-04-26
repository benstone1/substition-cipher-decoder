//
//  ContentView.swift
//  SubstitutionCipherDecoder
//
//  Created by Benjamin Stone on 3/25/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private let buttonInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
     
    var body: some View {
        VStack {
            Text("Panda Decoder")
                .font(.largeTitle)
                .padding(50)
            Spacer()
            Button(action: openCamera) {
                Text("Scan a puzzle").foregroundColor(.white)
            }.padding(buttonInsets)
                .background(Color.blue)
                .cornerRadius(3.0)
            Text(text).lineLimit(nil)
            if !text.isEmpty {
                Button(action: decode) {
                    Text("Decode").foregroundColor(.white)
                }.padding(buttonInsets)
                    .background(Color.blue)
                    .cornerRadius(3.0)
                Text(decodedText).lineLimit(nil)
            }
            Spacer()
        }.sheet(isPresented: self.$isShowingScannerSheet) { self.makeScannerView() }
    }
     
    @State private var isShowingScannerSheet = false
    @State private var text: String = ""
    @State private var decodedText: String = ""
     
    private func openCamera() {
        isShowingScannerSheet = true
    }
    
    private func decode() {
        let decoder = SubstitutionCiperDecoder()
        let words = text.components(separatedBy: " ")
        self.decodedText = decoder.decode(words: words).joined(separator: " ")
    }
     
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in
            if let text = textPerPage?.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines) {
                self.text = text
            }
            self.isShowingScannerSheet = false
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
