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

struct NutritionData: Codable, Equatable {
    var name: String
    var calories_kcal: Int
    var carb_g: Int
    var protein_g: Int
    var fat_g: Int
    
    init(name: String = "", calories_kcal: Int = 0, carb_g: Int = 0, protein_g: Int = 0, fat_g: Int = 0) {
        self.name = name
        self.calories_kcal = calories_kcal
        self.carb_g = carb_g
        self.protein_g = protein_g
        self.fat_g = fat_g
    }
    
    init(mealList: [Meal]) {
        self.init()
        
        for nutritionData in mealList.map({ $0.nutritionData }) {
            self.calories_kcal += nutritionData.calories_kcal
            self.carb_g += nutritionData.carb_g
            self.protein_g += nutritionData.protein_g
            self.fat_g += nutritionData.fat_g
        }
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
