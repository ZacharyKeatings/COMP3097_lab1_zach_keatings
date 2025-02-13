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
    @State private var timeLeft = 5
    @State private var timer: Timer?

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
        resetTimer()
        
        if attempts >= 10 {
            showAlert = true
        } else {
            generateNewNumber()
        }
    }

    func generateNewNumber() {
        number = Int.random(in: 1...100)
        timeLeft = 5
    }

    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        attempts = 0
        timeLeft = 5
        generateNewNumber()
        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeLeft > 0 {
                self.timeLeft -= 1
            } else {
                self.wrongAnswers += 1
                self.attempts += 1
                if self.attempts >= 10 {
                    self.showAlert = true
                }
                self.generateNewNumber()
            }
        }
    }

    func resetTimer() {
        timer?.invalidate()
        startTimer()
    }

    var body: some View {
        VStack {
            Text("\(number)")
                .font(.largeTitle)
                .padding()

            Text("Time left: \(timeLeft)s")
                .font(.headline)
                .foregroundColor(timeLeft <= 2 ? .red : .black)

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
        .onAppear { startTimer() }
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
