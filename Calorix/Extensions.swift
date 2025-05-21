//
//  Extensions.swift
//  Calorix
//
//  Created by Kai Zheng on 5/15/25.
//

import Foundation
import SwiftUI

public extension Image {
    
    init?(data: Data) {
        guard let image = UIImage(data: data) else { return nil }
        self = .init(uiImage: image)
    }
    
}
