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
    
    init(id: UUID = .init(), nutritionData: NutritionData = .init(), imageData: Data? = nil, timestamp: Date = .init(), mealTime: MealTime = .breakfast) {
        self.id = id
        self.nutritionData = nutritionData
        self.imageData = imageData
        self.timestamp = timestamp
        self.mealTime = mealTime
    }
    
}

public enum MealTime: String, Codable, CaseIterable, CustomStringConvertible{
    case breakfast
    case lunch
    case snack
    case dinner
    
    public var description: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .snack:
            return "Snack"
        case .dinner:
            return "Dinner"
        }
    }
}
