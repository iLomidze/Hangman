//
//  dataTwoPlayers.swift
//  Hangman
//
//  Created by ilomidze on 26.04.21.
//

import Foundation


class DataTwoPlayers {
    var player1Name: String!
    var player2Name: String!
    
    var player1Word: String!
    var player2Word: String!
    
    var player1Point: Int!
    var player2Point: Int!
    
    init() {
        self.player1Name = "Player 1"
        self.player2Name = "Player 2"
        self.player1Word = "Crocodile"
        self.player2Word = "Lion"
        self.player1Point = 0
        self.player2Point = 0
    }
    
    init(player1Name: String, player2Name: String, player1Word: String, player2Word: String, player1Point: Int, player2Point: Int) {
        self.player1Name = player1Name
        self.player2Name = player2Name
        self.player1Word = player1Word
        self.player2Word = player2Word
        self.player1Point = player1Point
        self.player2Point = player2Point
    }
}
