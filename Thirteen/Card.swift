//
//  Card.swift
//  Thirteen
//
//  Created by Kevin Largo on 1/6/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

import Foundation

class Card {
  /*let*/
  var contents: String! //String containing suit and value
  var rankValue: Int!     //rank value represented as an integer
  var suitValue: Int!     //suit value represented as an integer
  let suits = ["♠️","♣️","♦️","♥️"]
  var selected = false     //if selected, then highlight this card
  
  init() {
    self.contents = ""
    self.rankValue = 16
    self.suitValue = 4
  }
  
  init(rank: Int, suit: Int) {
    var r: String //used for String-casting
    
    self.rankValue = rank
    self.suitValue = suit
    
    switch rank {
    case 11:
      r = "J"
    case 12:
      r = "Q"
    case 13:
      r = "K"
    case 14:
      r = "A"
    case 15:
      r = "2"
    default:
      r = String(rank)
    }
    
    self.contents = r + suits[suit]
  }
}