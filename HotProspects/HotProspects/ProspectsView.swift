//
//  ProspectsView.swift
//  HotProspects
//
//  Created by BPS.Dev01 on 7/3/23.
//
import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    
    @EnvironmentObject var prospects: Prospects
    @State private var isScanning = false
    @State private var showingConfirmation = false
    @State private var sortOption: sortBy = .name
    
    enum FilterType {
        case contacted, uncontacted, none
    }
    
    enum sortBy {
        case name, date
    }
    
    let filter: FilterType
    
    var body: some View {
        NavigationStack {
            
            List(sortProspects(prospects: filteredProspects, by: sortOption)) { prospect in
                HStack {
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.email)
                            .foregroundColor(.secondary)
                    }
                    
                    if filter == .none && prospect.isContacted {
                        Image(systemName: "checkmark.seal.fill")
                    }
                }

                
                .swipeActions {
                    if prospect.isContacted {
                        Button {
                            prospects.toggle(prospect)
                        } label: {
                            Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                        }
                        .tint(.blue)
                    } else {
                        Button {
                            prospects.toggle(prospect)
                        } label: {
                            Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                        }
                        .tint(.green)
                        
                        Button {
                            addNotification(for: prospect)
                        } label: {
                            Label("Remind Me", systemImage: "bell")
                        }
                        .tint(.orange)
                    }
                }
            }
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isScanning = true
                        } label: {
                            Label("Scan", systemImage: "qrcode.viewfinder")
                        }
                    }
                    
                    ToolbarItem {
                        Button {
                            showingConfirmation = true
                        } label: {
                            Label("Sort by", systemImage: "list.bullet")
                        }
                    }
                    
                }
            
                .sheet(isPresented: $isScanning) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "New User\nhiram@mail.com", completion: handleScan)
                }
            
                .confirmationDialog("Sort by", isPresented: $showingConfirmation) {
                    Button("Alphabetical order") { sortOption = .name }
                    Button("Most recents first") { sortOption = .date }
                    Button("Cancel", role: .cancel) { }
                }

        }
        
    }
    
    func sortProspects(prospects: [Prospect], by: sortBy) -> [Prospect] {
        switch by {
        case .name:
            return prospects.sorted {
                $0.name < $1.name
            }
        case .date:
            return prospects.sorted {
                $0.date > $1.date
            }
        }
    }
    
    var title: String {
        switch filter {
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        case .none:
            return "Everyone"
        }
    }
    
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        case .none:
            return prospects.people
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isScanning = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.email = details[1]
            prospects.add(person)
            
        case .failure(let failure):
            print("Scanning failed: \(failure.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("No authorization for notifications.")
                    }
                }
            }
            
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
