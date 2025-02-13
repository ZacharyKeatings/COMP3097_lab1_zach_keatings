//
//  ContentView.swift
//  Lab1_Zach_Keatings
//
//  Created by Zach Keatings on 2025-02-13.
//

import SwiftUI

struct ContentView: View {
    @State private var number: Int = Int.random(in: 2...100)
    @State private var previousNumber: Int = 0
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var attempts = 0
    @State private var showAlert = false
    @State private var timeLeft = 5
    @State private var timer: Timer?
    @State private var animateNumber = false 

    // Prime number checker
    func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        for i in 2..<n where n % i == 0 { return false }
        return true
    }

    // Handle answer selection
    func checkAnswer(isPrimeSelected: Bool) {
        guard !showAlert else { return }

        if isPrime(number) == isPrimeSelected {
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

    // Generate a new number while ensuring no consecutive repeats
    func generateNewNumber() {
        var newNumber: Int
        repeat {
            newNumber = Int.random(in: 2...100)
        } while newNumber == previousNumber
        
        previousNumber = newNumber
        number = newNumber
        timeLeft = 5

        withAnimation(.spring()) { 
            animateNumber = true
        }
    }

    // Handle automatic failure due to timeout
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

    // End the game and show the alert
    func endGame() {
        showAlert = true
        timer?.invalidate()
    }

    // Reset game state and restart
    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        attempts = 0
        timeLeft = 5
        showAlert = false
        generateNewNumber()
        startTimer()
    }

    // Start or restart the timer
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

    // Reset timer without duplicating it
    func resetTimer() {
        timer?.invalidate()
        timeLeft = 5
        startTimer()
    }

    var body: some View {
        VStack {
            // Display the current number with animation
            Text("\(number)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .padding()
                .scaleEffect(animateNumber ? 1.2 : 1.0)
                .opacity(animateNumber ? 1 : 0)
                .animation(.spring(), value: animateNumber)

            // Timer display
            Text("Time left: \(timeLeft)s")
                .font(.title)
                .foregroundColor(timeLeft <= 2 ? .red : .black)
                .padding()
                .animation(.easeInOut, value: timeLeft)

            // Buttons for prime/not prime choices
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

            // Score display
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
