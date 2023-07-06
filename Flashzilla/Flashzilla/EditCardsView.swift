//
//  EditCardsView.swift
//  Flashzilla
//
//  Created by BPS.Dev01 on 7/6/23.
//

import SwiftUI

struct EditCardsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add New Card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add", action: addCard)
                }
                
                ForEach(cards, id:\.self) { card in
                    VStack(alignment: .leading) {
                        Text(card.prompt)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(card.answer)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete { index in
                    removeCards(at: index)
                }
            }
            
            .navigationTitle("Edit view")
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
        }
        .onAppear(perform: loadData)
        
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false || trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: newAnswer)
        cards.insert(card, at: 0)
        saveData()
        
        newPrompt = ""
        newAnswer = ""
    }
    
    func done() {
        dismiss()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
}

struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
