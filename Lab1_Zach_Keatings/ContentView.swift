//
//  ContentView.swift
//  Lab1_Zach_Keatings
//
//  Created by Zach Keatings on 2025-02-13.
//

import SwiftUI

struct ContentView: View {
    @State private var number: Int = Int.random(in: 1...100)
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var attempts = 0
    @State private var showAlert = false

    func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        for i in 2..<n {
            if n % i == 0 { return false }
        }
        return true
    }

    func checkAnswer(isPrimeSelected: Bool) {
        let correct = isPrime(number) == isPrimeSelected
        if correct {
            correctAnswers += 1
        } else {
            wrongAnswers += 1
        }
        attempts += 1
        if attempts >= 10 {
            showAlert = true
        } else {
            generateNewNumber()
        }
    }

    func generateNewNumber() {
        number = Int.random(in: 1...100)
    }

    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        attempts = 0
        generateNewNumber()
    }

    var body: some View {
        VStack {
            Text("\(number)")
                .font(.largeTitle)
                .padding()

            HStack {
                Button("Prime") {
                    checkAnswer(isPrimeSelected: true)
                }
                .padding()

                Button("Not Prime") {
                    checkAnswer(isPrimeSelected: false)
                }
                .padding()
            }

            Text("Correct: \(correctAnswers)  Wrong: \(wrongAnswers)")
                .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("You got \(correctAnswers) correct out of 10."),
                dismissButton: .default(Text("Restart")) {
                    resetGame()
                }
            )
        }
    }
}
