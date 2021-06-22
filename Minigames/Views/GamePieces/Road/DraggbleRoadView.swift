//
//  DraggbleRoadView.swift
//  Minigames
//
//  Created by Tomer Israeli on 20/06/2021.
//

import SwiftUI
import Combine

struct DraggbleRoadView<Game: SettlersGame>: View {
    
    @ObservedObject var boardVM: BoardViewModel<Game>
    
    init(boardVM: BoardViewModel<Game>) {
        self.boardVM = boardVM
        
        
    }
    
    var body: some View {
        RoadView<Game>(for: boardVM.gameVM.localPlayer)
            .shadow(color: shadowColor, radius: 10)
            .shadow(color: shadowColor, radius: 10)
            .rotationEffect(angle)
            .animation(.linear)
            .draggableGamePiece($boardVM.draggedRoadLocation) {
                
            }
            .environmentObject(boardVM)

    }
    
    private var angle: Angle {
        if let angle = boardVM.draggedRoadHoveringRoadPath?.angle {
            return .radians(angle.remainder(dividingBy: Double.pi))
        } else {
            return .zero
        }
    }
    
    
    var shadowColor: Color {
        guard let valid = boardVM.draggedRoadIsValid else { return .clear }
        return valid ? .green : .red
    }
    
}
