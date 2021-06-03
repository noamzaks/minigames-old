//
//  GameView.swift
//  Minigames
//
//  Created by Tomer Israeli on 02/06/2021.
//

import SwiftUI

struct GameView<Game: SettlersGame>: View {
    
    @ObservedObject var gameVM: SettlersGameViewModel<Game>
    
    var body: some View {
        VStack {
            PlayersBarView(gameVM: gameVM)
            BoardView(gameVM: gameVM)
            ResourceBarView(player: gameVM.localPlayer)
        }
        .padding(.vertical)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameVM: mocGameViewModel)
            .preferredColorScheme(.light)
    }
}