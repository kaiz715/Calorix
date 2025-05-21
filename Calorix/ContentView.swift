//
//  ContentView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/9/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    @State private var viewModel = ViewModel()
    @Binding var meal: Meal
    @State private var isShowingCameraView = true
    
    var body: some View {
        if isShowingCameraView {
            CameraView(meal: $meal)
                .ignoresSafeArea()
                .onChange(of: meal.nutritionData) {
                    isShowingCameraView = false
                }
        }
        else {
            MealNutritionView(meal: $meal)
                .background(Color.blue)
        }
        
        
    }
}

#Preview {
    @Previewable @State var meal: Meal = .init()
    ContentView(meal: $meal)
}
