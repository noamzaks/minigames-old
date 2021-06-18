//
//  BuildingsModifier.swift
//  Minigames
//
//  Created by Tomer Israeli on 05/06/2021.
//

import SwiftUI

struct BuildingsOverlayModifier<BuildingView>: ViewModifier where BuildingView: View{
    
    var buildings: [Building]
    var viewForBuilding: (Building, Float) -> BuildingView
    var hexagonRadius: Float
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            ForEach(buildings, id: \.self) { building in
                viewForBuilding(building, hexagonRadius)
                    .rotationEffect(.radians(building.angle))
                    .offset(offset(for: building))
            }
        }
    }
    
    private func offset(for building: Building) -> CGSize {
        var position = building.position * hexagonRadius
        // the building position is in a coordinate system where y axes is pointed up, unlike the screen coordinate system.
        position.reverseY()
        return position.asCGSize
    }
    
}

extension HexagonStack {
    
    func buildingsOverlay<BuildingView: View> (for buildings: [Building],viewForBuilding: @escaping (Building, Float) -> BuildingView) -> some View {
        
        self.modifier(BuildingsOverlayModifier(buildings: buildings,
                                               viewForBuilding: viewForBuilding,
                                               hexagonRadius: self.viewModel.radius))
    }
    
}
