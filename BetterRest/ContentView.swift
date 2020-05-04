//
//  ContentView.swift
//  BetterRest
//
//  Created by Adam S on 2020-05-02.
//  Copyright © 2020 Adam S. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    @State var generalMessage = ""
    @State var coffeeCount = [1,2,3,4,5,6,7,8,9,10]

    var body: some View {
        
    
        NavigationView {
            
            Form {
                
                Section(header: Text("When do you want to wake up").font(.headline)){
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                
                
                Section(header: Text("Desired amount of sleep").font(.headline)){
                    Stepper(value: $sleepAmount, in: 3...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
            
                Section(header: Text("Daily Coffee Intake").font(.headline)){
                    
                    Picker(selection: $coffeeAmount, label: EmptyView()) {
                        ForEach(0 ..< coffeeCount.count) {
                            Text("\(self.coffeeCount[$0])")
                            
                        }
                    }.pickerStyle(DefaultPickerStyle())
                }
                
                Section(header: Text("Your recommended bedtime is").font(.headline)){
                    Text(calculateBedtime())
                        .font(.title)
                        .foregroundColor(.black)
                }
                
            }
            .navigationBarTitle("BetterRest")
    
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour +
                minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
            
        } catch {
            return "Sorry, there was a problem calculating your bedtime"
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

