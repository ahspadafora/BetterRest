//
//  ContentView.swift
//  BetterRest
//
//  Created by Amber Spadafora on 10/9/20.
//  Copyright © 2020 Amber Spadafora. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    static var defaultWakeUpTime: Date {
        var wakeUp = DateComponents()
        wakeUp.hour = 7
        wakeUp.minute = 0
        return Calendar.current.date(from: wakeUp) ?? Date()
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeup = defaultWakeUpTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    func calculateBedTime(){
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeup - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is..."
        }
        catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment:.leading, spacing: 0) {
                    Text("When do you want to wake up?").font(.headline)
                    DatePicker("Please enter a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                VStack(alignment:.leading, spacing: 0) {
                    Text("Desired amount of sleep").font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                VStack(alignment:.leading, spacing: 0) {
                    Text("Amount of coffee cups drank").font(.headline)
                    
                    Picker(selection: $coffeeAmount, label: Text("Choose a number of coffees")) {
                        ForEach(1..<20) { coffeeAmount in
                            if coffeeAmount == 1 {
                                Text("1 cup")
                            } else {
                                Text("\(coffeeAmount) cups")
                            }
                        }
                    }
                    
                }
                
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: calculateBedTime) {
                    Text("Calculate")
                })
            }.alert(isPresented: $showingAlert) { () -> Alert in
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
