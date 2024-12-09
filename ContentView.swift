//
//  ContentView.swift
//  Caltrack
//
//  Created by Darren Chambers on 12/8/24.
//
import SwiftUI
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AddMealView()) {
                    Text("Add Meal")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                NavigationLink(destination: ViewMealsView()) {
                    Text("View Meals")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Calorie Tracker")
        }
    }
}


#Preview {
    ContentView()
}
