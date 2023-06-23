//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by BPS.Dev01 on 6/23/23.
//
import CoreData
import SwiftUI

struct FilteredList: View {
    
    @FetchRequest var fetchRequest: FetchedResults<Singer>
    
    var body: some View {
        List(fetchRequest, id:\.self){ singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedlastName)")
        }
    }
    
    init(filter: String, predicate: String, sortOrder: [NSSortDescriptor]) {
        _fetchRequest = FetchRequest<Singer>(sortDescriptors: sortOrder, predicate: NSPredicate(format: "lastName \(predicate) %@", filter))
    }
}

/*
struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList()
    }
}
*/
