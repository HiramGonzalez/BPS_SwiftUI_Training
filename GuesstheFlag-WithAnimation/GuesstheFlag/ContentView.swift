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
    
    @State private var optionTapped = 0
    @State private var flagChoosed = 4
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
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
                            .accessibilityLabel(labels[countries[correctAnswer], default: "Unknown flag"])
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImage(image: countries[number])
                        }
                        .rotation3DEffect(number == flagChoosed ? .degrees(Double(optionTapped)) : .degrees(0), axis: (x: 0, y: 1, z:0))
                        .opacity(flagChoosed < 4 && number != flagChoosed ? 0.25 : 1)
                        .scaleEffect(flagChoosed < 4 && number != flagChoosed ? 0.65 : 1)
                        
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
        
        withAnimation{
            optionTapped += 360
            flagChoosed = number
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagChoosed = 4
    }
    
    func reset() {
        round = 0
        score = 0
        flagChoosed = 4
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
