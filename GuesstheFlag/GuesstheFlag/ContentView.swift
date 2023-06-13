//
//  ContentView.swift
//  GuesstheFlag
//
//  Created by BPS.Dev01 on 6/9/23.
//

import SwiftUI

struct FlagImage: View {
    
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var message = ""
    @State private var showingResult = false
    @State private var round = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                Text("Guess the flag")
                    .foregroundStyle(.white)
                    .font(.largeTitle.weight(.bold))
                
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.primary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImage(image: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            Text(message)
        }
        .alert("Game Over!", isPresented: $showingResult){
            Button("Reset Game", action: reset)
        } message: {
            Text("Your final score was \(score) points")
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
            message = "That's the flag of \(countries[correctAnswer])"
            score += 1
        } else {
            scoreTitle = "Wrong"
            message = "Oh no! That's the flag of \(countries[number])"
            if score > 0 {
                score -= 1
            }
        }
        
        showingScore = true
        round += 1
        if round == 8 {
            showingResult = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        round = 0
        score = 0
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
