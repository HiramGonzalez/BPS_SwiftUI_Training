//
//  ContentView.swift
//  Cupcake_Corner
//
//  Created by BPS.Dev01 on 6/20/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var order = Order()
    
    var body: some View {
        NavigationStack {
            Form{
                Section {
                    Picker("Select your cake type", selection: $order.type){
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    } .pickerStyle(.menu)
                    
                    
                    Stepper("Number of cakes:  \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section{
                    Toggle("Any special requests?", isOn: $order.sepecialRequestEnabled.animation())
                    
                    if order.sepecialRequestEnabled {
                        Toggle("Add extra forsting?", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            
            .navigationTitle("Cupcake Corner")
        }
        
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
