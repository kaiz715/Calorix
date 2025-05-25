//
//  StackedActivityRingView.swift
//  Calorix
//
//  Created by Kai Zheng on 5/19/25.
//

import SwiftUI

public func getRingValue(nutrient: Int, nutrientGoal: Int) -> CGFloat {
    return CGFloat(Float(nutrient)/Float(nutrientGoal))
}

public struct StackedActivityRingViewConfig {
    var lineWidth: CGFloat
    var firstRingColor: Color = .green
    var secondRingColor: Color = .blue
    var thirdRingColor: Color = .red
    var fourthRingColor: Color = .yellow
    var size: CGFloat
    
    init(lineWidth: CGFloat = 33.3, size: CGFloat = 350) {
        self.lineWidth = lineWidth
        self.size = size
    }
    
    init(size: CGFloat) {
        self.lineWidth = size/10.5
        self.size = size
    }
}

struct StackedActivityRingView: View {
    var config: StackedActivityRingViewConfig
    var firstRingValue: CGFloat
    var secondRingValue: CGFloat?
    var thirdRingValue: CGFloat?
    var fourthRingValue: CGFloat?
    var kcal: Int?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ActivityRingView(progress: firstRingValue, mainColor: config.firstRingColor, lineWidth: config.lineWidth)
                    .frame(width: geo.size.width, height: geo.size.height)
                if let secondRingValue = secondRingValue {
                    ActivityRingView(progress: secondRingValue, mainColor: config.secondRingColor, lineWidth: config.lineWidth)
                        .frame(width: geo.size.width - (2*config.lineWidth), height: geo.size.height - (2*config.lineWidth))
                }
                if let thirdRingValue = thirdRingValue{
                    ActivityRingView(progress: thirdRingValue, mainColor: config.thirdRingColor, lineWidth: config.lineWidth)
                        .frame(width: geo.size.width - (4*config.lineWidth), height: geo.size.height - (4*config.lineWidth))
                }
                if let fourthRingValue = fourthRingValue {
                    ActivityRingView(progress: fourthRingValue, mainColor: config.fourthRingColor, lineWidth: config.lineWidth)
                        .frame(width: geo.size.width - (6*config.lineWidth), height: geo.size.height - (6*config.lineWidth))
                }
                
                if let kcal = kcal{
                    VStack {
                        Text(String(kcal))
                        Text("kcal")
                    }
                }
            }
        }
        .frame(width: config.size, height: config.size)
    }
}

#Preview {
    @Previewable @State var calorieRingValue: CGFloat = 0.5
    @Previewable @State var carbsRingValue: CGFloat = 0.3
    @Previewable @State var proteinRingValue: CGFloat = 0.2
    @Previewable @State var fatRingValue: CGFloat = 0.6

    StackedActivityRingView(config: .init(), firstRingValue: calorieRingValue, secondRingValue: carbsRingValue, thirdRingValue: proteinRingValue, fourthRingValue: fatRingValue, kcal: 150)
}

