//
//  UFOCategory.swift
//  UFOTracker
//
//  Created by Daniel Bachar on 2/2/22.
//

import Foundation

enum UFOCategory: Int, Identifiable {
    case strange = 0
    case mysteriousLights
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .strange:
            return "Strange Flyers"
        case .mysteriousLights:
            return "Mysterious Lights"
        }
    }
    
    var types: [UFOType] {
        switch self {
        case .mysteriousLights:
            return [.mysteriousLights]
        case .strange:
            return [.blob, .lampshade]
        }
    }
}
