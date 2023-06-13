//
//  ContentView.swift
//  BetterRest
//
//  Created by BPS.Dev01 on 6/12/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0 {
        didSet{
            calculateBedTime()
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .onChange(of: wakeUp){ newValue in
                            calculateBedTime()
                        }
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                }
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount){ newValue in
                            calculateBedTime()
                        }
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section {
                    Picker("Please enter number of cups", selection: $coffeeAmount){
                        ForEach(1..<21) { number in
                            Text(number == 1 ? "1 cup" : "\(number) cups")
                        }
                    }
                    .onChange(of: coffeeAmount){ newValue in
                        calculateBedTime()
                    }
                    .labelsHidden()
                } header: {
                    Text("Daily coffee intake")
                }
                
                Section {
                    Text(alertMessage)
                        .font(.largeTitle)
                } header: {
                    Text("Recommended bedtime")
                }

            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
        }
        .onAppear(){
            calculateBedTime()
        }
        .alert(alertTitle, isPresented: $showingAlert){
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was an error calculting your bedtime."
        }
        
        //showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
