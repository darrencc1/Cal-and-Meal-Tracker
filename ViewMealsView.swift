//
//  ViewMealsView.swift
//  Caltrack
//
//  Created by Darren Chambers on 12/8/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
struct ViewMealsView: View {
    @State private var mealsByType: [String:[Meal]] = [:]
    private let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snacks"]

    var body: some View {
            List {
                ForEach(mealTypes, id: \..self) { type in
                    Section(header: Text(type).font(.headline)) {
                        if let meals = mealsByType[type], !meals.isEmpty {
                            ForEach(meals) { meal in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(meal.name)
                                            .font(.headline)
                                        Text("Calories: \(meal.calories)")
                                        Text("Protein: \(meal.protein)")
                                        Text("Carbs: \(meal.carbs)")
                                    }
                                    Spacer()
                                }
                            }
                            .onDelete { offsets in
                                deleteMeal(at: offsets, forType: type)
                            }
                        } else {
                            Text("No meals added.")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Meals")
            .onAppear(perform: loadMeals)
        }

        private func loadMeals() {
            let db = Firestore.firestore()
            db.collection("meals").getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading meals: \(error.localizedDescription)")
                } else {
                    let allMeals = snapshot?.documents.compactMap { document -> Meal? in
                        let data = document.data()
                        return Meal(
                            id: document.documentID,
                            name: data["name"] as? String ?? "",
                            calories: data["calories"] as? Int ?? 0,
                            protein: data["protein"] as? Int ?? 0,
                            carbs: data["carbs"] as? Int ?? 0,
                            type: data["type"] as? String ?? ""
                        )
                    } ?? []

                    mealsByType = Dictionary(grouping: allMeals, by: { $0.type })
                }
            }
        }

        private func deleteMeal(at offsets: IndexSet, forType type: String) {
            guard let meals = mealsByType[type] else { return }
            let db = Firestore.firestore()

            offsets.forEach { index in
                let meal = meals[index]
                db.collection("meals").document(meal.id).delete { error in
                    if let error = error {
                        print("Error deleting meal: \(error.localizedDescription)")
                    } else {
                        print("Meal deleted successfully!")
                    }
                }
            }

            mealsByType[type]?.remove(atOffsets: offsets)
        }
    }

    struct Meal: Identifiable {
        var id: String
        var name: String
        var calories: Int
        var protein: Int
        var carbs: Int
        var type: String
    }

