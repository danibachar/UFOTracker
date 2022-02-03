//
//  UFOType.swift
//  UFOTracker
//
//  Created by Daniel Bachar on 2/2/22.
//

import Foundation

enum UFOType {

    case blob
    case lampshade
    case mysteriousLights

    var name: String {
        switch self {
        case .blob:
            return "Blob"
        case .lampshade:
            return "Lamp Shade"
        case .mysteriousLights:
            return "Mysterious Lights"
        }
    }
    var imageName: String {
        switch self {
        case .blob:
            return "blob"
        case .lampshade:
            return "lampshade"
        case .mysteriousLights:
            return "scribble"
        }
    }
}
