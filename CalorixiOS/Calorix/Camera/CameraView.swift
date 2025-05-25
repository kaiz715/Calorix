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
    @State var loadingNutritionData: Bool = false

    
    func recieveNutritionData(nutritionData: NutritionData, imageData: Data) {
        if let newMeal = newMeal {
            newMeal.nutritionData = nutritionData
            newMeal.imageData = imageData
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
                Image(decorative: image, scale: 1.5)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .bottom)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .overlay(alignment: .bottom) {
                        buttonView()
                            .frame(height: geometry.size.height * 0.15)
                            .background(.black.opacity(0.75))
                    }
                    .overlay(alignment: .center) {
                        if loadingNutritionData {
                            loadingNutritionView()
                                .frame(height: geometry.size.height, alignment: .center)
                                .background(.black.opacity(0.75))
                        }
                    }
            } else {
                ContentUnavailableView("Loading Camera", systemImage: "camera.fill")
                                        .frame(width: geometry.size.width,
                           height: geometry.size.height)
            }
        }
        .onChange(of: viewModel.currentPhoto) {
            loadingNutritionData = true
        }
        .onChange(of: viewModel.nutritionData) {
            if let vmNutritionData = viewModel.nutritionData, let vmImageData = viewModel.imageData {
                recieveNutritionData(nutritionData: vmNutritionData, imageData: vmImageData)
            }
        }
        .navigationBarTitle(Text("Take Meal Photo"), displayMode: .inline)
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
                                .frame(width: 75, height: 75)
                            Circle()
                                .fill(.white)
                                .frame(width: 63, height: 63)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func loadingNutritionView() -> some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                ProgressView("Calculating Nutrition…")
                    .foregroundColor(.white)
                Spacer()
            }
            Spacer()
        }
    }
}
