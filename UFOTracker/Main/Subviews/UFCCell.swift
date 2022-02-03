//
//  UFCCell.swift
//  UFOTracker
//
//  Created by Daniel Bachar on 2/2/22.
//

import SwiftUI

struct UFCCell: View {

    enum Consts {
        // Size and padding
        static let ufoTypeImageSize = CGSize(width: 40, height: 30)
        static let detailsStackSpacing = 4.0

        static let rightArrowImageName = "chevron.right"
    }
    
    let sighting: Sighting
    var image: Image {
        if let fromAsset = UIImage(named: sighting.type.imageName) {
            return Image(uiImage: fromAsset)
        }
        return Image(systemName: sighting.type.imageName)
    }
    var body: some View {
        HStack {
            
            image
                .resizable()
                .foregroundColor(Color.greenHazeColor)
                .frame(width: Consts.ufoTypeImageSize.width,
                       height: Consts.ufoTypeImageSize.height,
                       alignment: .leading)
                .scaledToFit()

            VStack(alignment: .leading, spacing: Consts.detailsStackSpacing) {
                Text(sighting.date.formatted(date: .long, time: .omitted))
                    .font(.system(size: 17))
                    .foregroundColor(Color.labelColor)
                Text("\(sighting.speed) knots · \(sighting.type.name)")
                    .font(.system(size: 13))
                    .foregroundColor(Color.secondaryLabelColor)
            }
            Spacer()
            Text(sighting.date.formatted(date: .omitted, time: .shortened))
                .font(.system(size: 17))
                .foregroundColor(Color.secondaryLabelColor)
            Image(systemName: Consts.rightArrowImageName)
                .foregroundColor(Color.secondaryLabelColor)

        }
    }
}

struct UFCCell_Previews: PreviewProvider {
    static var previews: some View {
        UFCCell(sighting: Sighting.random(by: [UFOCategory.strange,
                                               UFOCategory.mysteriousLights].flatMap { $0.types }))
    }
}
