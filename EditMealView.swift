//
//  EditMealView.swift
//  Caltrack
//
//  Created by Darren Chambers on 12/8/24.
//
import SwiftUI
import Firebase

struct EditMealView: View {
    var mealID: String
    @State private var mealName: String = ""
    @State private var calorieCount: String = ""
    @State private var proteinCount: String = ""
    @State private var carbCount: String = ""
    @State private var successMessage: String = ""
    @State private var showingSuccessAlert: Bool = false

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

            Button(action: updateMeal) {
                Text("Update Meal")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .alert(isPresented: $showingSuccessAlert) {
                Alert(title: Text("Success"), message: Text(successMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear(perform: loadMealData)
        .navigationTitle("Edit Meal")
    }

    private func loadMealData() {
        let db = Firestore.firestore()
        db.collection("meals").document(mealID).getDocument { document, error in
            if let document = document, document.exists {
                mealName = document.data()? ["name"] as? String ?? ""
                calorieCount = String(document.data()? ["calories"] as? Int ?? 0)
                proteinCount = String(document.data()? ["protein"] as? Int ?? 0)
                carbCount = String(document.data()? ["carbs"] as? Int ?? 0)
            }
        }
    }

    private func updateMeal() {
        let calories = Int(calorieCount) ?? 0
        let protein = Int(proteinCount) ?? 0
        let carbs = Int(carbCount) ?? 0

        guard !mealName.isEmpty else {
            successMessage = "Meal name cannot be empty."
            showingSuccessAlert = true
            return
        }

        let db = Firestore.firestore()
        db.collection("meals").document(mealID).updateData([
            "name": mealName,
            "calories": calories,
            "protein": protein,
            "carbs": carbs
        ]) { error in
            if let error = error {
                successMessage = "Failed to update meal: \(error.localizedDescription)"
            } else {
                successMessage = "Meal updated successfully!"
            }
            showingSuccessAlert = true
        }
    }
}
