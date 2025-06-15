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
    @State var showImage = false
    @FocusState var servingSizeFocusState: Bool
    @FocusState var isInputActive: Bool
    
    var body: some View {
        VStack{
            ScrollView{
                HStack {
                    TextField("Meal Name", text: $meal.nutritionData.name)
                        .font(.largeTitle)
                        .foregroundStyle(.primary)
                        .autocorrectionDisabled(true)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                NutritionDetailView(nutritionValues: getTotalNutritionValues(from: meal.nutritionData), dailyNutritionGoal: dailyNutritionGoal)
                    .padding(.bottom, 40)
                
                HStack{
                    Text("Serving Size (g)")
                    Spacer()
                    TextField("Grams", value: $meal.nutritionData.serving_size_g, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100, height: 30)
                        .focused($isInputActive)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                
                                Button("Done") {
                                    isInputActive = false
                                }
                            }
                        }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                HStack{
                    Text("Number of Servings")
                    Spacer()
                    TextField("", value: $meal.nutritionData.servings, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100, height: 30)
                        .focused($isInputActive)
                        
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                HStack{
                    Text("Meal Time")
                    Spacer()
                    Picker("Meal Time", selection: $meal.mealTime) {
                        ForEach(MealTime.allCases, id: \.self) { value in
                            Text(String(describing: value))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                if meal.imageData != nil{
                    Button("Show Meal Picture") {
                        showImage = true
                    }
                    .font(.title3)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                
            }
        }
        .sheet(isPresented: $showImage){
            if let imageData = meal.imageData{
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .scaledToFit()
                    .presentationDetents([.large])
            }
        }
    }
}

#Preview {
    @Previewable @State var meal: Meal = Meal(id: .init(), nutritionData: .init(name: "Chicken", serving_size_g: 100, servings: 1, nutrition_values_per_100g: NutritionValues(calories_kcal: 1500, carb_g: 50, protein_g: 40, fat_g: 30)), imageData: UIImage(named: "sample")?.jpegData(compressionQuality: 1), timestamp: Date(), mealTime: .breakfast)
    MealNutritionView(meal: meal, dailyNutritionGoal: .init())
}
