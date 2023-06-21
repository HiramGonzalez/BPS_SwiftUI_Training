//
//  AddressView.swift
//  Cupcake_Corner
//
//  Created by BPS.Dev01 on 6/21/23.
//

import SwiftUI

struct AddressView: View {
    
    @ObservedObject var order: Order
    /*
    private var isAddressValid: Bool {
        if order.name.isEmpty || order.streetAddress.isEmpty || order.city.isEmpty || order.zip.isEmpty {
            return false
        }
        
        return true
    }*/
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.isAddressValid == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
