//
//  MealNutritionView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/14/25.
//

import SwiftUI

struct MealNutritionView: View {
    @Bindable var meal: Meal
    var dailyNutritionGoal: DailyNutritionGoal
    
    var body: some View {
        VStack(spacing: 20){
            ScrollView{
                HStack {
                    TextField("Meal Name", text: $meal.nutritionData.name)
                        .font(.largeTitle)
                        .foregroundStyle(.primary)
                        .autocorrectionDisabled(true)
                    Spacer()
                }.padding(.horizontal, 20)
                if let mealImageData = meal.imageData {
                    Image(data: mealImageData)?
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.8
                        }
                }
                else {
                    Text("No Image")
                }
                VStack{
                    NutritionDetailView(nutritionData: meal.nutritionData, dailyNutritionGoal: dailyNutritionGoal)
                        .padding(.bottom, 40)
                    
                    HStack{
                        Text("Serving Size")
                        Spacer()
                        TextField("Grams", value: $meal.nutritionData.calories_kcal, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100, height: 30)
                    }
                    HStack{
                        Text("Meal Time")
                        Spacer()
                        Picker("Meal Time", selection: $meal.mealTime) {
                            ForEach(MealTime.allCases, id: \.self) { value in
                                Text(String(describing: value))
                            }
                        }
                    }
                }
                .padding()
                
            }
        }// on dismiss or exit save model context
    }
}

#Preview {
    @Previewable @State var meal: Meal = Meal(id: .init(), nutritionData: .init(name: "Chicken", calories_kcal: 1500, carb_g: 50, protein_g: 40, fat_g: 30), imageData: UIImage(named: "sample")?.jpegData(compressionQuality: 1), timestamp: Date(), mealTime: .breakfast)
    MealNutritionView(meal: meal, dailyNutritionGoal: .init())
}
