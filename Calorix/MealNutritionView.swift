//
//  MealNutritionView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/14/25.
//

import SwiftUI

struct MealNutritionView: View {
    
    @Binding var meal: Meal
    
    var body: some View {
        VStack(spacing: 20){
            ScrollView{
                HStack {
                    TextField("Meal Name", text: $meal.nutritionData.name)
                        .font(.largeTitle)
                        .autocorrectionDisabled(true)
                    Spacer()
                }
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
                    HStack{
                        Text("Calories")
                        Spacer()
                        TextField("Calories", value: $meal.nutritionData.calories_kcal, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100, height: 30)
                    }
                    HStack{
                        Text("Carbohydrates")
                        Spacer()
                        TextField("Carbohydrates", value: $meal.nutritionData.carb_g, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100, height: 30)
                    }
                    HStack{
                        Text("Protiens")
                        Spacer()
                        TextField("Protiens", value: $meal.nutritionData.protein_g, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100, height: 30)
                    }
                    HStack{
                        Text("Fats")
                        Spacer()
                        TextField("Fats", value: $meal.nutritionData.fat_g, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100, height: 30)
                    }
                }
                .padding(.horizontal)
                
            }
        }// on dismiss or exit save model context
    }
}

#Preview {
    @Previewable @State var meal: Meal = Meal(id: .init(), nutritionData: .init(), imageData: UIImage(named: "sample")?.jpegData(compressionQuality: 1), timestamp: Date(), mealTime: .breakfast)
    MealNutritionView(meal: $meal)
}
