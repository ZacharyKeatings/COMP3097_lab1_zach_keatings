//
//  ContentView.swift
//  Lab1_Zach_Keatings
//
//  Created by Zach Keatings on 2025-02-13.
//

struct ContentView: View {
    @State private var number: Int = Int.random(in: 1...100)
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var feedback: String? = nil

    func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        for i in 2..<n {
            if n % i == 0 { return false }
        }
        return true
    }

    func checkAnswer(isPrimeSelected: Bool) {
        let correct = isPrime(number) == isPrimeSelected
        feedback = correct ? "✔️" : "❌"
        if correct {
            correctAnswers += 1
        } else {
            wrongAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.feedback = nil
            self.generateNewNumber()
        }
    }

    func generateNewNumber() {
        number = Int.random(in: 1...100)
    }

    var body: some View {
        VStack {
            Text("\(number)")
                .font(.largeTitle)
                .padding()

            if let feedback = feedback {
                Text(feedback)
                    .font(.largeTitle)
                    .padding()
            }

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
    }
}
