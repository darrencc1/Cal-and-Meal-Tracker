//
//  AddMealView.swift
//  Caltrack
//
//  Created by Darren Chambers on 12/8/24.
//
import Foundation
import SwiftUI
import Firebase

struct AddMealView: View {
    @State private var mealName: String = ""
    @State private var calorieCount: String = ""
    @State private var proteinCount: String = ""
    @State private var carbCount: String = ""
    @State private var mealType: String = "Breakfast"
    @State private var successMessage: String = ""
    @State private var showingSuccessAlert: Bool = false

    let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snacks"]

    var body: some View {
        VStack {
            TextField("Meal Name", text: $mealName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Calories", text: $calorieCount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)

            TextField("Protein", text: $proteinCount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)

            TextField("Carbs", text: $carbCount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)

            Picker("Meal Type", selection: $mealType) {
                ForEach(mealTypes, id: \..self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button(action: saveMeal) {
                Text("Save Meal")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .alert(isPresented: $showingSuccessAlert) {
                Alert(title: Text("Success"), message: Text(successMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Add Meal")
    }

    private func saveMeal() {
        // Allow some fields to be blank
        let calories = Int(calorieCount) ?? 0
        let protein = Int(proteinCount) ?? 0
        let carbs = Int(carbCount) ?? 0

        guard !mealName.isEmpty else {
            successMessage = "Meal name cannot be empty."
            showingSuccessAlert = true
            return
        }

        // Save to Firestore
        let db = Firestore.firestore()
        db.collection("meals").addDocument(data: [
            "name": mealName,
            "calories": calories,
            "protein": protein,
            "carbs": carbs,
            "type": mealType
        ]) { error in
            if let error = error {
                successMessage = "Failed to save meal: \(error.localizedDescription)"
            } else {
                successMessage = "Meal saved successfully!"
                // Reset input fields
                mealName = ""
                calorieCount = ""
                proteinCount = ""
                carbCount = ""
                mealType = "Breakfast"
            }
            showingSuccessAlert = true // Trigger the alert after completion
        }
    }
}

#Preview {
    AddMealView()
}
