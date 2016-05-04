//
//  Player.swift
//  Thirteen
//
//  Created by Kevin Largo on 1/14/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

import Foundation

class Player {
  var name: String?
  var hand = [Card]() //remaining cards
  var inRotation = true
  var out = false
  var play = [Card?]() //cards that Player attempts to play
  var turn = false

  init(name: String) {
    self.name = name
  }
  
  func discardSelected() {
    //selected cards are removed from hand
    for i in 0...(hand.count - 1) {
      if(hand[i].selected) {
        hand[i].contents = "" //temporarily used to "delete" a card
        hand[i].rankValue = 16
        hand[i].suitValue = 4
      }
    }
  }
  
  func handIsEmpty() -> Bool {
    for i in 0...(hand.count - 1) {
      //if any card is NOT blank
      if(hand[i].contents != "") {
        return false//return to game
      }
    }
    
    //otherwise, player is out and has won
    out = true
    return true
  }
}