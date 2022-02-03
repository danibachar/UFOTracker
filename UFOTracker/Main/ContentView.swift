//
//  ContentView.swift
//  UFOTracker
//
//  Created by Daniel Bachar on 2/2/22.
//

import SwiftUI

struct ContentView: View {

    enum Consts {
        // Size and padding
        static let pickerTopPadding = 12.0
        static let listCellSidePadding = 10.0
        // Colors
        static let plusButtonIconName = "plus"
    }

    @ObservedObject private var viewModel: MainViewModelImpl = MainViewModelImpl(ufoService: UFOServiceImpl())
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $viewModel.selectedCategoryIndex) {
                    ForEach(0..<viewModel.categories.count, id: \.self) { category in
                        Text(viewModel.categories[category].title)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, Consts.pickerTopPadding)
                
                List {
                    ForEach(viewModel.sightings, id:\.self) { sighting in
                        UFCCell(sighting: sighting)
                            .padding([.top,.bottom], Consts.listCellSidePadding)
                    }
                    .onDelete(perform: { s in
                        viewModel.deleteSwipe = s
                    })
                }
                .listStyle(.plain)
            }
            .navigationBarTitle(viewModel.title,
                                displayMode: .large)
            .navigationBarItems(trailing:
                Button {
                    viewModel.addPressed.toggle()
                } label: {
                    Image(systemName: Consts.plusButtonIconName)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.greenHazeColor)
                }
            )
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
