//
//  NutritionModel.swift
//  Calorix
//
//  Created by Kai Zheng on 5/12/25.
//

import Foundation
import UIKit


func getNutritionData(from imageData: Data) async -> NutritionData? {
    let session = URLSession(configuration: .default)
    let boundary = UUID().uuidString
    let fileName = "\(UUID().uuidString).jpeg"
    if let url = URL(string: getImageNutritionUrl) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let clrf = "\r\n"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)")
        body.append(clrf)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"")
        body.append(clrf)
        body.append("Content-Type: image/jpeg")
        body.append(clrf)
        body.append(clrf)
        body.append(imageData)
        body.append(clrf)
        body.append("--\(boundary)--")
        body.append(clrf)

        request.httpBody = body
        do {
            let (data, response) =  try await session.data(for: request)
            let decoder = JSONDecoder()
            let nutritionData = try decoder.decode(NutritionData.self, from: data)
            return nutritionData
        } catch {
            // do somehting with error
            print("Error decoding: \(error)")
            return nil
        }
    }
    else {
        return nil
    }
}

struct NutritionValues: Codable, Equatable {
    var calories_kcal: Int
    var carb_g: Int
    var protein_g: Int
    var fat_g: Int
    
    init(calories_kcal: Int = 0, carb_g: Int = 0, protein_g: Int = 0, fat_g: Int = 0) {
        self.calories_kcal = calories_kcal
        self.carb_g = carb_g
        self.protein_g = protein_g
        self.fat_g = fat_g
    }
    
    init(mealList: [Meal]) {
        self.init()
        
        for nutritionData in mealList.map({ $0.nutritionData }) {
            self.calories_kcal += nutritionData.nutrition_values_per_100g.calories_kcal * nutritionData.servings * nutritionData.serving_size_g / 100
            self.carb_g += nutritionData.nutrition_values_per_100g.carb_g * nutritionData.servings * nutritionData.serving_size_g / 100
            self.protein_g += nutritionData.nutrition_values_per_100g.protein_g * nutritionData.servings * nutritionData.serving_size_g / 100
            self.fat_g += nutritionData.nutrition_values_per_100g.fat_g * nutritionData.servings * nutritionData.serving_size_g / 100
        }
    }
}

func getTotalNutritionValues(from nutritionData: NutritionData) -> NutritionValues {
    return NutritionValues(
        calories_kcal: nutritionData.serving_size_g * nutritionData.servings * nutritionData.nutrition_values_per_100g.calories_kcal / 100,
        carb_g: nutritionData.serving_size_g * nutritionData.servings * nutritionData.nutrition_values_per_100g.carb_g / 100,
        protein_g: nutritionData.serving_size_g * nutritionData.servings * nutritionData.nutrition_values_per_100g.protein_g / 100,
        fat_g: nutritionData.serving_size_g * nutritionData.servings * nutritionData.nutrition_values_per_100g.fat_g / 100)
}

struct NutritionData: Codable, Equatable {
    var name: String
    var serving_size_g: Int
    var servings: Int
    var nutrition_values_per_100g: NutritionValues
    
    init(name: String = "", serving_size_g: Int = 0, servings: Int = 0, nutrition_values_per_100g: NutritionValues = .init()) {
        self.name = name
        self.serving_size_g = serving_size_g
        self.servings = servings
        self.nutrition_values_per_100g = nutrition_values_per_100g
    }
}

struct DailyNutritionGoal: Codable, Equatable {
    var calories_kcal: Int
    var carb_g: Int
    var protein_g: Int
    var fat_g: Int
    
    init(calories_kcal: Int = 2000, carb_g: Int = 300, protein_g: Int = 100, fat_g: Int = 50) {
        self.calories_kcal = calories_kcal
        self.carb_g = carb_g
        self.protein_g = protein_g
        self.fat_g = fat_g
    }
}

extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}
