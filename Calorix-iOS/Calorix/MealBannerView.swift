//
//  MealBannerView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/21/25.
//

import SwiftUI

struct MealBannerView: View {
    var config = StackedActivityRingViewConfig(size: 60)
    var meal: Meal
    var body: some View {
        HStack{
            if let imageData = meal.imageData {
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
            } else {
                Image("fork.knife.circle.fill")
                    .resizable()
                    .foregroundStyle(.gray)
                    .frame(width: 50, height: 50)
            }
            
            Text(meal.nutritionData.name)
                .font(.headline)
                .padding(.leading, 10)
            Spacer()
            StackedActivityRingView(config: config, firstRingValue: getRingValue(nutrient: meal.nutritionData.nutrition_values_per_100g.calories_kcal * meal.nutritionData.servings * meal.nutritionData.serving_size_g / 100, nutrientGoal: 2000), kcal: meal.nutritionData.nutrition_values_per_100g.calories_kcal * meal.nutritionData.servings * meal.nutritionData.serving_size_g / 100)
        }.alignmentGuide(.listRowSeparatorLeading) { _ in
            return 0
        }
    }
}

#Preview {
    MealBannerView(meal: .init(id: .init(), nutritionData: .init(name: "Whole Chicken", serving_size_g: 100, servings: 1, nutrition_values_per_100g: NutritionValues(calories_kcal: 1500, carb_g: 50, protein_g: 40, fat_g: 30)), timestamp: Date(), mealTime: .breakfast))
}
