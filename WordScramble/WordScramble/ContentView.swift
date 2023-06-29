//
//  ContentView.swift
//  WordScramble
//
//  Created by BPS.Dev01 on 6/13/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Text("Your score is: \(score)")
                
                Section {
                    ForEach(usedWords, id:\.self) { word in
                        
                        HStack{
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                            
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(word)
                        .accessibilityHint("\(word.count) letters")
                    }
                }
                
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("Restart", action: startgame)
            }
        }
        .onSubmit {
            addNewWord()
        }
        .onAppear(perform: startgame)
        .alert(alertTitle, isPresented: $showingError){
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just  make them up, you know!")
            return
        }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Word is very short", message: "The word must have 3 characters at least!")
            return
        }
        
        guard isNotRootWord(word: answer) else {
            wordError(title: "Original word", message: "You can't use the original word.")
            return
        }
        
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        score += ((answer.count * 2) + usedWords.count)
    }

    
    func startgame() {
        score = 0
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return mispelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count >= 3
    }
    
    func isNotRootWord(word: String) -> Bool {
        return word != rootWord
    }
    
    
    func wordError(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingError = true
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
