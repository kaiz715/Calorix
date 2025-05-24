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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Meal.self)
    }
}
