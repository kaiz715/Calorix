//
//  CameraView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/13/25.
//

import SwiftUI
import SwiftData

struct CameraView: View {
    @State private var viewModel = ViewModel()
    @Binding var path: NavigationPath
    @Query var meals: [Meal]
    @Environment(\.modelContext) var context
    @State var newMeal: Meal?
    
    
    private static let barHeightFactor = 0.15
    
    func recieveNutritionData(nutritionData: NutritionData, imageData: Data) {
        if let newMeal = newMeal {
            newMeal.nutritionData = nutritionData
            newMeal.imageData = imageData
            newMeal.timestamp = Date()
        } else {
            newMeal = Meal(nutritionData: nutritionData, imageData: imageData, timestamp: Date(), mealTime: .breakfast)
        }
        
        context.insert(newMeal!)
        do {
            try context.save()
        } catch {
            print("Error adding new meal: \(error)")
        }
        
        path.removeLast()
    }
    
    var body: some View {
        GeometryReader { geometry in
            if let image = viewModel.currentFrame {
                
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
                    .overlay(alignment: .bottom) {
                        buttonView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(.black.opacity(0.75))
                    }
            } else {
                ContentUnavailableView("Camera feed interrupted", systemImage: "xmark.circle.fill")
                                        .frame(width: geometry.size.width,
                           height: geometry.size.height)
            }
        }
        .onChange(of: viewModel.nutritionData) {
            if let vmNutritionData = viewModel.nutritionData, let vmImageData = viewModel.imageData {
                recieveNutritionData(nutritionData: vmNutritionData, imageData: vmImageData)
            }
        }
    }
    
    private func buttonView() -> some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    viewModel.cameraManager.takePhoto()
                } label: {
                    Label {
                    } icon: {
                        ZStack {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 62, height: 62)
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                
                Spacer()
            }
            Spacer()
        }
    }
}
