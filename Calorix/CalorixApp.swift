//
//  CalorixApp.swift
//  Calorix
//
//  Created by Kai Zheng on 5/9/25.
//

import SwiftUI
import SwiftData

@main
struct CalorixApp: App {
    
    @State var meal: Meal = .init()

    var body: some Scene {
        WindowGroup {
            ContentView(meal: $meal)
        }.modelContainer(for: Meal.self)
    }
}
