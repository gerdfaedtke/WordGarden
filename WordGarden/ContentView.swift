//
//  ContentView.swift
//  WordGarden
//
//  Created by Gerd Faedtke on 19.01.24.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var gameStatusMessage = "How many Guesses to Uncover the Hidden Word?"
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldisFocused: Bool
    
    private let wordsToGuess = ["SWIFT", "DOG", "CAT"]
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                Spacer()
                
                VStack (alignment: .trailing) {
                    Text("Words to Guessed: \(wordsToGuess.count - wordsGuessed + wordsMissed)")
                    Text("Words Game: \(wordsToGuess.count)")
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            // TODO: Switch to wordsToGuess[currentWord]
            Text(revealedWord)
                .font(.title)
            
            if playAgainHidden {
                HStack {
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        //.onChange(of: guessedLetter) { _ in
                        .onChange(of: guessedLetter) { oldValue, newValue in
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChr = guessedLetter.last
                            else {
                                return
                            }
                            guessedLetter = String(lastChr).uppercased()
 
                        }
                        .onSubmit {
                            guard guessedLetter != "" else {
                                return
                            }
                            guessALetter()
                        }
                    
                        .focused($textFieldisFocused)
                    
                    
                    Button("Guess a Letter") {
                        guessALetter()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                Button("Another Word?") {
                    // TODO: Another Word Button action here
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            
            
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear() {
        wordToGuess = wordsToGuess[currentWordIndex]
            // CREATE A STRING FROM A REPEATING VALUE
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
        }
    }
    
    func guessALetter() {
        textFieldisFocused = false
        lettersGuessed = lettersGuessed + guessedLetter
        revealedWord = ""
        // loop through all letters in wordToGuess
        for letter in wordToGuess {
            // Check if letter in wordToGuess is in lettersGuessed (i.e. did you guess this letter already?)
            if lettersGuessed.contains(letter) {
                revealedWord = revealedWord + "\(letter)"
            } else {
                // if not, add an underscore + a blank space, to revealedWord
                revealedWord = revealedWord + "_ "
            }
        }
        revealedWord.removeLast()
        guessedLetter = ""
    }
}

#Preview {
    ContentView()
}
