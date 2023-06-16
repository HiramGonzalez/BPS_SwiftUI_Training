//
//  ContentView.swift
//  iExpense
//
//  Created by BPS.Dev01 on 6/15/23.
//

import SwiftUI

struct giveStyle: ViewModifier {
    let amount: Double
    
    func body(content: Content) -> some View {
        if amount < 10 {
            content
                .foregroundColor(.green)
        } else if amount >= 10 && amount < 100 {
            content
                .foregroundColor(.yellow)
        } else {
            content
                .foregroundColor(.red)
        }
    }
}

extension Text {
    func giveStyleBasedOnAmount(amount: Double) -> some View {
        modifier(giveStyle(amount: amount))
    }
}

struct ContentView: View {
    
    @StateObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items) { item in
                        if item.type == "Personal"{
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                        .giveStyleBasedOnAmount(amount: item.amount)
                                    Text(item.type)
                                        .font(.subheadline)
                                        .giveStyleBasedOnAmount(amount: item.amount)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .giveStyleBasedOnAmount(amount: item.amount)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        removeItems(at: indexSet)
                    }
                }
                
                Section("Business") {
                    ForEach(expenses.items) { item in
                        if item.type == "Business"{
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                        .giveStyleBasedOnAmount(amount: item.amount)
                                    Text(item.type)
                                        .font(.subheadline)
                                        .giveStyleBasedOnAmount(amount: item.amount)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .giveStyleBasedOnAmount(amount: item.amount)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        removeItems(at: indexSet)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
        
    }
    
    func removeItems(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
