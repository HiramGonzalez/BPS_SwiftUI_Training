//
//  ContentView.swift
//  AccessibilityProject
//
//  Created by BPS.Dev01 on 6/29/23.
//

import SwiftUI

struct ContentView: View {
    let images = ["ales-krivec-15949",
                  "galina-n-189483",
                  "kevin-horstmann-141705",
                  "nicolas-tissot-335096"]
    
    let labels = [ "Tulips",
                   "Frozen tre buds",
                   "Sunflowers",
                   "Fireworks" ]
    
    @State private var selectedPicture = Int.random(in: 0...3)
    
    @State private var value = 10
    
    var body: some View {
        VStack {
            Text("Value: \(value)")
            
            Button("Increment") {
                value += 1
            }
            
            Button("Decrement") {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value += 1
                
            case .decrement:
                value -= 1
                
            default:
                print("Not handled. ")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
