//
//  SettlersGameViewModel.swift
//  Minigames
//
//  Created by Tomer Israeli on 02/06/2021.
//

import Foundation
import Combine
import UIKit.UIColor

class SettlersGameViewModel: ObservableObject {
    
    @Published private var game: SettlersGame
    
    @Published var localPlayerIsPlaying: Bool = false
    @Published var currentPlayerID: UUID? = nil
    
    @Published var tiles: [Tile] = []
    @Published var harbors: [Harbor] = []
    @Published var buildings: [Building] = []
    @Published var players: [Player] = []
    @Published var trades: [Trade] = []
    
    @Published var gameState: SettlersGameState = SettlersGameState.waitingForPlayers(connectedPlayers: [])
        
    private var cancellables: Array<AnyCancellable> = .init()
    
    init(_ player: Player) {
        self.game = LocalSettlersGame(joinAs: player)
        
        game.currentPlayerIDPublisher
            .map{ $0 == self.game.localPlayerID }
            .assign(to: \.localPlayerIsPlaying, on: self)
            .store(in: &cancellables)
        
        game.currentPlayerIDPublisher
            .assign(to: \.currentPlayerID, on: self)
            .store(in: &cancellables)

        game.tilesPublisher
            .assign(to: \.tiles, on: self)
            .store(in: &cancellables)
        
        game.harborsPublisher
            .assign(to: \.harbors, on: self)
            .store(in: &cancellables)
        
        game.playersPublisher
            .assign(to: \.players, on: self)
            .store(in: &cancellables)
        
        game.tradesPublisher
            .sink {
                self.trades = $0.filter({$0.bidderID != self.game.localPlayerID })
            }
            .store(in: &cancellables)
        
        game.gameStatePublisher
            .assign(to: \.gameState, on: self)
            .store(in: &cancellables)
        
        game.buildingsPublisher
            .assign(to: \.buildings, on: self)
            .store(in: &cancellables)
    }
    
    var localPlayer: Player{
        if let localPlayer = players.first(where: { $0.id == game.localPlayerID }) {
            return localPlayer
        } else {
            fatalError("couldnt find local player in players array")
        }
    }
    
    //MARK: Intents
    public func rollDice(){
        let _ = game.rollDice()
    }
    
    //MARK: UI support
}

#if DEBUG

let mocGameViewModel = SettlersGameViewModel(Player("tomer",.blue, URL(string: "https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2018/07/bird-eagle-flight.jpg?h=5bbcce53&itok=wIQc9zhg")))

#endif
