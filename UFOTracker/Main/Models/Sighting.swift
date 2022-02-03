//
//  Sighting.swift
//  UFOTracker
//
//  Created by Daniel Bachar on 2/2/22.
//

import Foundation

struct Sighting: Identifiable, Hashable {
    let date: Date
    let type: UFOType
    let speed: UInt32
    
    var id: Double { return date.timeIntervalSince1970 }
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(type.name)
        hasher.combine(speed)
    }
    
    static func random(by types: [UFOType]) -> Self {
        Sighting(date: Date(), type: types.randomElement()!, speed: arc4random_uniform(30))
    }
}
