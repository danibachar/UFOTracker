//
//  ViewModel.swift
//  UFOTracker
//
//  Created by Daniel Bachar on 2/2/22.
//

import Foundation
import SwiftUI
import Combine

protocol MainViewModel {
    // Outputs
    var title: String { get }
    var sightings: [Sighting] { get  }
    var categories: [UFOCategory] { get }
    var onError: Error? { get set }
    var isLoading: Bool { get set }
    // Inputs
    var addPressed: Bool { get set }
    var deleteSwipe: IndexSet { get set }
    var selectedCategoryIndex: Int { get set }
}

final class MainViewModelImpl: ObservableObject, MainViewModel {

    // Outputs
    @Published private(set) var title: String = "UFO Sightings"
    @Published private(set) var sightings = [Sighting]()
    @Published private(set) var categories = [UFOCategory.strange, UFOCategory.mysteriousLights]
    @Published var onError: Error?
    @Published  var isLoading: Bool = false
    // Inputs
    @Input var addPressed = false
    @Input var deleteSwipe = IndexSet()
    @Input var selectedCategoryIndex = 0
    //
    private var cancelBag = Set<AnyCancellable>()

    init(ufoService: UFOService) {
        // Selection Logic
        $selectedCategoryIndex
            .dropFirst()
            .map { index in return self.categories[index] }
            .flatMap { category in
                ufoService.fetchSightings(for: category)
            }
            .receive(on: RunLoop.main)
            .sink { error in
                print("DB: - currentCategory error \(error) ")
            } receiveValue: { [weak self] sightings in
                self?.sightings = sightings
            }
            .store(in: &cancelBag)
        
        // Add logic
        $addPressed
            .dropFirst()
            .map { [weak self] _ -> [UFOType] in
                guard let self = self else { return [] }
                return self.categories[self.selectedCategoryIndex].types
            }
            .flatMap { [weak self] allTypes -> AnyPublisher<[Sighting], Error> in
                guard let self = self else {
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return ufoService
                    .createNewSighting(Sighting.random(by: allTypes), for: self.categories[self.selectedCategoryIndex])
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                print("DB: $addPressed error \(error)")
            }, receiveValue: { [weak self]sightings in
                self?.sightings = sightings
            })
            .store(in: &cancelBag)
        
        // Delete logic
        $deleteSwipe
            .dropFirst()
            .flatMap { [weak self] indexSet -> AnyPublisher<[Sighting], Error> in
                guard let self = self else {
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                var sightings = self.sightings
                sightings.remove(atOffsets: indexSet)
                
                return ufoService.delete(sightings: sightings, in: self.categories[self.selectedCategoryIndex])
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                print("DB: $deleteSwipe error \(error)")
            }, receiveValue: { [weak self] newSightings in
                self?.sightings = newSightings
            })
            .store(in: &cancelBag)
        
        ufoService.fetchCategories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print("DB: fetchCategories completion - \(error)")
            }, receiveValue: { [weak self] categories in
                self?.categories = categories
            })
            .store(in: &cancelBag)
    }
}
