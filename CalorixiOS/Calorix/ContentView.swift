//
//  ContentView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/9/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var dailyNutritionGoal: DailyNutritionGoal = .init()
    
    var body: some View {
        MealsListView(nutritionGoal: dailyNutritionGoal)
        
    }
}

#Preview {
    ContentView()
}
