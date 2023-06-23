//
//  ContentView.swift
//  CoreDataProject
//
//  Created by BPS.Dev01 on 6/22/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    
    enum predicate {
        case beginsWith, lessThan, isIncludedIn
    }
    
    var body: some View {
        VStack {
            List{
                ForEach(countries, id: \.self) { country in
                    Section(country.wrappedLargeName) {
                        ForEach(country.candyArray, id: \.self) {
                            Text($0.wrappedName)
                        }
                    }
                }
            }
            
            Button("Add examples") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.largeName = "United Kingdom"
                
                let candy2 = Candy(context: moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.largeName = "United Kingdom"

                let candy3 = Candy(context: moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.largeName = "United Kingdom"

                let candy4 = Candy(context: moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.largeName = "Switzerland"
                
                try? moc.save()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
