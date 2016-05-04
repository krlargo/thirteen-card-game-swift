//
//  Deck.swift
//  Thirteen
//
//  Created by Kevin Largo on 1/11/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

import Foundation

class Deck {
  var cards = [Card]()  //use var instead of let to make mutable
                        //allows for removeAtIndex to be used
  
  init () { //creates the SORTED deck of cards
    for r in 3...15 { //for loop for each rank
      for s in 0...3 {//for loop for each suit
        cards.append(Card(rank:r, suit:s))
      }
    }
  }

  func dealRandomCard() -> Card { //needs a count check whenever it is called
    var randomCard: Card
    
    if(cards.count == 0) {
      print("\n Deck is empty, cannot deal anymore random cards. \n Please provide deck count-checker prior to calling function 'dealRandomCard()'.", terminator: "")
      exit(100)
    }
    
    let index = (arc4random() % UInt32(cards.count))
    randomCard = cards[Int(index)]
    cards.removeAtIndex(Int(index))
    
    return randomCard
  }

  func printDeck() { //Debug function to check if deck's cards contents were created correctly.
    for i in 0...51 {
      print((cards[i].contents! as String) + " ")
      
      if((i + 1)%13 == 0) {
        print("\n", terminator: "")
      }
    }
  }
}