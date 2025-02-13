//
//  ContentView.swift
//  Lab1_Zach_Keatings
//
//  Created by Zach Keatings on 2025-02-13.
//

import SwiftUI

struct ContentView: View {
    @State private var number: Int = Int.random(in: 1...100)

    func generateNewNumber() {
        number = Int.random(in: 1...100)
    }

    var body: some View {
        VStack {
            Text("\(number)")
                .font(.largeTitle)
                .padding()

            HStack {
                Button("Prime") {
                    generateNewNumber()
                }
                .padding()

                Button("Not Prime") {
                    generateNewNumber()
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

