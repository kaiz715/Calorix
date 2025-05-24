//
//  MealsListView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/15/25.
//

import SwiftUI
import SwiftData
import Foundation

struct MealsListView: View {
    @State private var path = NavigationPath()
    @State private var selectedDate = Date()
    let nutritionGoal: DailyNutritionGoal
    
    var body: some View {
        HStack {
            Button {
                changeDate(by: -1)
            } label: {
                Image(systemName: "chevron.left.circle.fill")
            }
            Text(dateToString(selectedDate))
            Button {
                changeDate(by: 1)
            } label: {
                Image(systemName: "chevron.right.circle.fill")
            }
        }
        
        MealsListViewHelper(path: $path, selectedDate: selectedDate, nutritionGoal: nutritionGoal)
        
    }
    
    private func changeDate(by days: Int) {
        selectedDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate)!
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

struct MealsListViewHelper: View {
    @Binding var path: NavigationPath
    @Environment(\.modelContext) private var context
    @Query private var meals: [Meal]
    let selectedDate: Date
    let nutritionGoal: DailyNutritionGoal
    
    init(path: Binding<NavigationPath>, selectedDate: Date = Date(), nutritionGoal: DailyNutritionGoal) {
        self._path = path
        self.selectedDate = selectedDate
        self.nutritionGoal = nutritionGoal
        
        let dayStart = Calendar.current.startOfDay(for: selectedDate)
        let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
        _meals = Query(filter: #Predicate<Meal> {$0.timestamp >= dayStart && $0.timestamp < dayEnd })
    }
    
    var body: some View {
        NavigationStack(path: $path){
            NutritionDetailView(nutritionData: .init(mealList: meals), dailyNutritionGoal: nutritionGoal)
                .padding(.vertical, 20)
            
            List{
                mealTimeMealList(.breakfast)
                mealTimeMealList(.lunch)
                mealTimeMealList(.dinner)
                mealTimeMealList(.snack)
            }
            .listStyle(GroupedListStyle())
            .navigationDestination(for: Meal.self) { meal in
                MealNutritionView(meal: meal, dailyNutritionGoal: nutritionGoal)
            }
            .navigationDestination(for: MealTime.self) { mealTime in
                CameraView(path: $path, newMeal: .init(mealTime: mealTime))
            }
        }
    }
    
    private func mealTimeMealList(_ mealTime: MealTime) -> some View {
        return
            Section {
                ForEach (meals) { meal in
                    if meal.mealTime == mealTime {
                        NavigationLink(value: meal){
                            MealBannerView(meal: meal).padding(5)
                        }
                    }
                }
                .onDelete(perform: deleteMeals)
                NavigationLink(value: mealTime){
                    HStack{
                        Spacer()
                        Text("Add a Meal").foregroundStyle(.cyan)
                        Spacer()
                    }
                }
                
            } header: {
                Text(String(describing: mealTime))
            }.headerProminence(.increased)
        
    }
    
    private func deleteMeals(indexSet: IndexSet) {
        for index in indexSet {
            print("Deleting meal at index \(index)")
            context.delete(meals[index])
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    MealsListView(nutritionGoal: .init())
}
