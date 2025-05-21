//
//  MealModel.swift
//  Calorix
//
//  Created by Kai Zheng on 5/15/25.
//

import Foundation
import SwiftData

@Model
class Meal: Identifiable {
    @Attribute(.unique) var id: UUID
    var nutritionData : NutritionData
    @Attribute(.externalStorage) var imageData: Data?
    var timestamp: Date
    var mealTime: MealTime
    
    init(id: UUID = .init(), nutritionData: NutritionData, imageData: Data? = nil, timestamp: Date, mealTime: MealTime) {
        self.id = id
        self.nutritionData = nutritionData
        self.imageData = imageData
        self.timestamp = timestamp
        self.mealTime = mealTime
    }
    
    init() {
        self.id = .init()
        self.nutritionData = .init()
        self.imageData = nil
        self.timestamp = Date()
        self.mealTime = .breakfast
    }
    
}

public enum MealTime: String, Codable{
    case breakfast
    case lunch
    case snack
    case dinner
}
