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
        guard !showAlert else { return }  

        let correct = isPrime(number) == isPrimeSelected
        if correct {
            correctAnswers += 1
        } else {
            wrongAnswers += 1
        }
        attempts += 1

        if attempts >= 10 {
            endGame()
        } else {
            generateNewNumber()
            resetTimer()
        }
    }

    func generateNewNumber() {
        number = Int.random(in: 1...100)
        timeLeft = 5
    }

    func autoFail() {
        guard !showAlert else { return } 

        wrongAnswers += 1
        attempts += 1

        if attempts >= 10 {
            endGame()
        } else {
            generateNewNumber()
            resetTimer()
        }
    }

    func endGame() {
        showAlert = true
        timer?.invalidate()
    }

    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        attempts = 0
        timeLeft = 5
        showAlert = false
        generateNewNumber()
        startTimer()
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeLeft > 0 {
                self.timeLeft -= 1
            } else {
                self.autoFail()
            }
        }
    }

    func resetTimer() {
        timer?.invalidate()
        timeLeft = 5
        startTimer()
    }

    var body: some View {
        VStack {
            Text("\(number)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .padding()

            Text("Time left: \(timeLeft)s")
                .font(.title)
                .foregroundColor(timeLeft <= 2 ? .red : .black)
                .padding()
                .animation(.easeInOut, value: timeLeft)

            HStack(spacing: 40) {
                Button(action: { checkAnswer(isPrimeSelected: true) }) {
                    Text("Prime")
                        .font(.title2)
                        .frame(width: 150, height: 60)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }

                Button(action: { checkAnswer(isPrimeSelected: false) }) {
                    Text("Not Prime")
                        .font(.title2)
                        .frame(width: 150, height: 60)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
            }
            .padding(.top, 20)

            Text("Correct: \(correctAnswers)  |  Wrong: \(wrongAnswers)")
                .font(.title3)
                .padding(.top, 30)
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
