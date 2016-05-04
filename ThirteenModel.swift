//
//  ThirteenModel.swift
//  Thirteen
//
//  Created by Kevin Largo on 1/13/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

//>> MAKE POP UP MESSAGES <<//

/*

  0 - any play
  1 - singles (or 4 (bomb))
  2 - doubles
  3 - triples
  4 - bomb
  5 - straight
      - check if size matches
        - check if

-------------------

  bombs
  single 2:
  - 3 straight pairs
  - 4 of a kind

  double 2's:
  - 4 straight pairs

  triple 2's:
  - 5 straight pairs
 
  straight pairs
  - higher straight pairs

  4 of a kind
  - higher 4 of a kind

  [options]
  - bomb anything vs bomb only 2's
  - any bomb beats any bomb
  - bomb while out of rotation //probably won't use this oone
  - winner starts
  - lowest three starts
  - dragon is auto-win
  - all 2's is auto-win
  - "Flip" button vs Touch ID scanner
  - one winner or play until one loser

*/

import Foundation

class ThirteenModel {
  var cards: NSMutableArray = []
  var deck = Deck()
  var newRound = true
  var numOut = 0
  var numPassed = 0
  var play = 0
  var players: [Player] = [ Player(name: ""),
                            Player(name: ""),
                            Player(name: ""),
                            Player(name: "") ]
  var playedCards = [Card]()
  var playerIndex = 0
  
//-- INITIALIZE FUNCTIONS --//
  //creates card collection for played cards
  func initPlayedCards() {
    for _ in 0...11 {
      playedCards.append(Card())
    }
  }
  
  //deals random cards to all players
  func dealHands() {
    for i in 0...2 {    //three players
      for _ in 0...12 { //13 random cards
        players[i].hand.append(deck.dealRandomCard())
      }
    }
    
    //fourth player gets the rest of the deck
    for _ in 0...12 {
      players[3].hand = deck.cards
    }
    
    //auto-sort hands
    for i in 0...3 {
    players[i].hand.sortInPlace(inOrder)
    }
  }
  
  //moves playerIndex to player with lowest 3
  func findLowestThree() {
    for i in 0...3 {
      for j in 0...12 {
        if(players[i].hand[j].contents == "3♠️") {
          playerIndex = i
          return
        }
      }
    }
  }
  
//-- RECURRING FUNCTIONS --//
  func startNewRound() {
    for i in 0...3 {
      if(!players[i].out) {
        players[i].inRotation = true
      }
    }
    newRound = true
    nextInRotation()
    numPassed = 0
    play = 0
  }
  
  func nextInRotation() {
    //increment to next in-rotation player
    for _ in 0...3 {
      playerIndex = (playerIndex + 1) % 4
      if(players[playerIndex].inRotation && !players[playerIndex].out) {
        break
      }
    }
  }
  
  //plays cards from player's hand to table
  func playCards() -> Bool {
    newRound = false
    var playedCardIndex = 0
    
    //make all playedCards blank
    resetPlayedCards()
    
    //increment through hand, play any that are selected
    for i in 0...(players[playerIndex].hand.count - 1) {
      if(players[playerIndex].hand[i].selected) {
        
        //hard copy of card data
        playedCards[playedCardIndex].contents = players[playerIndex].hand[i].contents
        playedCards[playedCardIndex].rankValue = players[playerIndex].hand[i].rankValue
        playedCards[playedCardIndex].suitValue = players[playerIndex].hand[i].suitValue

        playedCardIndex++ //increment for each playedCard added
        
        if(playedCardIndex > 11) {
          break
        }
      }
      else {
        playedCards[playedCardIndex].contents = "" //make all other cards invisible
      }
    }
    
    if(playedCardIndex == 0) {//no cards were selected
      return false
    }
    
    //sort playedCards and remove selected cards from player's hands
    playedCards.sortInPlace(inOrder)
    players[playerIndex].discardSelected()
    players[playerIndex].hand.sortInPlace(inOrder)
    
    return true;
  }
  
//-- RULE FUNCTIONS--//
  func playIsValid(played:[Card]) -> Bool {
    return false
  }
  
/*
  - check if count matches (not for play == 0)
    - check if play matches
      - check if play is higher
*/
  //FREE PLAY
  func play0() -> Bool {
    //play1() singles
    //play2() pairs
    //play3() triples
    //play5() straights
    //play6() bomb during free play?
    return false
  }
  
  //SINGLES
  func play1() -> Bool {
    return false
  }
  
  //PAIRS
  func play2() -> Bool {
    return false
  }
  
  //TRIPLES OR 3-STRAIGHT
  func play3() -> Bool {
    return false
  }
  
  //BOMB OR 4-STRAIGHT
  func play4() -> Bool {
    return false
  }
  
  //STRAIGHTS
  func play5() -> Bool {
    return false
  }
  
  //BOMB
  func play6() -> Bool {
    return false
  }
  
  //temporary, should be able to rely on .count() function
  func numCards(cards: [Card]) -> Int {
    var count = 0
    for i in 0...cards.count - 1 {
      if(cards[i].contents != "") {
        count++
      }
      else {
        break
      }
    }
    return count
  }
//-- END RULE FUNCTIONS --//
  
  
//-- RESET FUNCTIONS --//
  //makes all played cards blank prior to loading for next play
  func resetPlayedCards() { //resets ALL playedCards before next set
    for i in 0...11 {
      if(playedCards[i].contents != "") {
        playedCards[i].contents = ""
        playedCards[i].rankValue = 16
        playedCards[i].suitValue = 4
      }
    }
  }
  
//-- ORDERING FUNCTIONS --//
  //ordering function for .sort()
  func inOrder(card1: Card, card2: Card) -> Bool {
    if(card1.rankValue != card2.rankValue) {
      return card1.rankValue < card2.rankValue
    }
    else {
      return card1.suitValue < card2.suitValue
    }
  }

  //ordering function for .sort()
  func leftwardPush(card1: Card, card2: Card) -> Bool {
    if(card1.contents == "") {
      return false
    }
    return true
  }
  
//-- AUTO-WIN FUNCTIONS --//
  func checkForAutowins() {
    checkForTwos()
    checkForDragon()
  }
  
  func checkForTwos() {
    var numTwos = 0
    
    for i in 0...3 {
      for j in 0...12 {
        if(players[i].hand[j].rankValue == 2) {
          numTwos++
        }
      }
      //if four 2's
      if(numTwos == 4) {
        setWinner(i)
        return
      }
      
      numTwos = 0 //reset count for next player
    }
  }
  
  func checkForDragon() {
    for i in 0...3 {
      for j in 0...12 {
        if((players[i].hand[j].rankValue + 3) != j) {
          break
        }
        setWinner(i)
        return
      }
    }
  }
  
  func checkForWins() {
    //will set player.out to true if true; nothing if false
    if(players[playerIndex].handIsEmpty()) {
      numOut++ //increment the number of players who are out
    }
  }
  
  func setWinner(winnerIndex: Int) {
    //announce that players[winnerIndex] won
  }
  
}