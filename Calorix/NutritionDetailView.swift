//
//  NutritionBannerView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/17/25.
//

import SwiftUI

struct NutritionDetailView: View {
    var nutritionValues: NutritionValues
    var dailyNutritionGoal: DailyNutritionGoal
    var config = StackedActivityRingViewConfig(size: 225)
    
    
    var body: some View {
        HStack{
            StackedActivityRingView(config: config, firstRingValue: getRingValue(nutrient: nutritionValues.calories_kcal, nutrientGoal: dailyNutritionGoal.calories_kcal), secondRingValue: getRingValue(nutrient: nutritionValues.carb_g, nutrientGoal: dailyNutritionGoal.carb_g), thirdRingValue: getRingValue(nutrient: nutritionValues.protein_g, nutrientGoal: dailyNutritionGoal.protein_g), fourthRingValue: getRingValue(nutrient: nutritionValues.fat_g, nutrientGoal: dailyNutritionGoal.fat_g))
            VStack{
                Text(String(nutritionValues.calories_kcal))
                    .foregroundStyle(config.firstRingColor)
                    .font(.system(size: 30, weight: .bold, design: .default))
                Text("calories")
                    .font(.system(size: 14, weight: .medium, design: .default))
                Spacer()
                Text(String(nutritionValues.carb_g))
                    .foregroundStyle(config.secondRingColor)
                    .font(.system(size: 30, weight: .bold, design: .default))
                Text("Carbs (g)")
                    .font(.system(size: 14, weight: .medium, design: .default))
                Spacer()
                Text(String(nutritionValues.protein_g))
                    .foregroundStyle(config.thirdRingColor)
                    .font(.system(size: 30, weight: .bold, design: .default))
                Text("Protien (g)")
                    .font(.system(size: 14, weight: .medium, design: .default))
                Spacer()
                Text(String(nutritionValues.fat_g))
                    .foregroundStyle(config.fourthRingColor)
                    .font(.system(size: 30, weight: .bold, design: .default))
                Text("Fats (g)")
                    .font(.system(size: 14, weight: .medium, design: .default))
            }
            .frame(height: 225)
            .padding(.leading, 20)
        }
    }
    
}

#Preview {
    NutritionDetailView(nutritionValues: NutritionValues(calories_kcal: 1400, carb_g: 50, protein_g: 40, fat_g: 30), dailyNutritionGoal: .init())
}
