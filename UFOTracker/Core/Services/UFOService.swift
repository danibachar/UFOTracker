//
//  UFOService.swift
//  UFOTracker
//
//  Created by Daniel Bachar on 2/2/22.
//

import Combine

protocol UFOService {
    // POST
    func createNewSighting(_ sighting: Sighting, for category: UFOCategory) -> AnyPublisher<[Sighting], Error>
    // Get
    func fetchCategories() -> AnyPublisher<[UFOCategory], Error>
    func fetchSightings(for category: UFOCategory) -> AnyPublisher<[Sighting], Error>
    // DELETE
    func delete(sightings: [Sighting], in category: UFOCategory) -> AnyPublisher<[Sighting], Error>

}

final class UFOServiceImpl {
    private var sightingsMap: [UFOCategory: [Sighting]] = [UFOCategory.strange:[],
                                                           UFOCategory.mysteriousLights:[]]
}

extension UFOServiceImpl: UFOService {
    // POST
    func createNewSighting(_ sighting: Sighting, for category: UFOCategory) -> AnyPublisher<[Sighting], Error> {
        sightingsMap[category]?.append(sighting)
        return fetchSightings(for: category)
    }
    // Get
    func fetchCategories() -> AnyPublisher<[UFOCategory], Error> {
        return Just(sightingsMap.keys.map { $0 }.sorted(by: { $0.rawValue < $1.rawValue }))
            // TODO more logic
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    func fetchSightings(for category: UFOCategory) -> AnyPublisher<[Sighting], Error> {
        return Just(sightingsMap[category] ?? [])
            // TODO more logic
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    // Delete
    func delete(sightings: [Sighting], in category: UFOCategory) -> AnyPublisher<[Sighting], Error> {
        sightingsMap[category] = sightingsMap[category]?.filter { sightings.contains($0) }
        return fetchSightings(for: category)
    }
}
