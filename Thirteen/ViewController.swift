//
//  ViewController.swift
//  Thirteen
//
//  Created by Kevin Largo on 1/4/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var playerName: UILabel!
  @IBOutlet weak var passButton: UIButton!
  @IBOutlet weak var flipButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet var cardButtons: [UIButton]!
  @IBOutlet var playedCards: [UIButton]!
  @IBOutlet weak var passedList: UILabel!
  
  var playerNames: [String] = ["", "", "", ""] //used to receive input names
  var facedown = true
  var game = ThirteenModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    for i in 0...3 {
      game.players[i].name = playerNames[i]
    }
    
    game.dealHands() //deal hands to each player
    game.findLowestThree() //shift turn to lowest 3 player
    game.initPlayedCards() //set up space for blank playedCards
    
    playerName.text = game.players[game.playerIndex].name! + "'s turn"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func touchCardButton(sender: UIButton) {
    if(facedown) {
      return //do nothing if facedown
    }
    
    let i = cardButtons.indexOf(sender)!
    
    //if "removed", do not allow to be selected
    if(game.players[game.playerIndex].hand[i].contents == "") {
      return
    }
    
    if(game.players[game.playerIndex].hand[i].selected) {
      sender.layer.borderWidth = 1
      sender.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha: 1).CGColor
      game.players[game.playerIndex].hand[i].selected = false
    }
    else {
      sender.layer.borderWidth = 2
      sender.layer.borderColor = UIColor(red:0, green:204/255.0, blue:0, alpha: 1.0).CGColor
      game.players[game.playerIndex].hand[i].selected = true
    }
  }
  
  @IBAction func touchFlipButton(sender: UIButton) {
    var i = 0
    for cardButton: UIButton in cardButtons {
      i = cardButtons.indexOf(cardButton)!
      
      //if face-down -> flip face-up
      if(facedown) {
        cardButton.setTitle(game.players[game.playerIndex].hand[i].contents, forState: UIControlState.Normal)
        cardButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        
        //if card was removed, make "invisible"
        if(game.players[game.playerIndex].hand[i].contents == "") {
          cardButton.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
          cardButton.layer.borderWidth = 0
        }
          
        //resets "invisibility" for next player's hand
        else {
          cardButton.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
          cardButton.layer.borderWidth = 1
        }
      }
        
      //if face-up -> flip face-down
      else { //flip cards
        cardButton.setTitle("", forState: UIControlState.Normal)
        cardButton.setBackgroundImage(UIImage(named: "Card Back"), forState: UIControlState.Normal)
        unselectCards()
      }
    }
    facedown = !facedown
  }

  @IBAction func touchPassButton(sender: UIButton) {
    if(game.newRound) {
      alertMustBeginNewRound()
      return
    }
    game.players[game.playerIndex].inRotation = false
    checkIfLastPlayerPassed()
    updatePassedList()
    game.numPassed++
    nextPlayer()
  }
  
  @IBAction func touchPlayButton(sender: UIButton) {
    if(!game.playCards()) {
      alertMustSelectCards()
      return
    }
    
    game.checkForWins()
    if(game.numOut == 1) {
      alertWinner() //first winner found
    }
    
    nextPlayer()
  }
  
  func nextPlayer() {
    let currentPlayer = game.playerIndex
    
    game.nextInRotation()
    
    //there is no one else in rotation
    if(currentPlayer == game.playerIndex) {
      game.startNewRound()
    }
    
    //reset UI for next turn
    setPlayedCardsFacedown()
    unselectCards()
    setPlayedCards()
    playerName.text = game.players[game.playerIndex].name! + "'s turn"
  }
  
  func checkIfLastPlayerPassed() {
    //if the last person to pass "passes", reset played cards.
    if(game.numPassed == (2 - game.numOut)) {
      game.resetPlayedCards()
      setPlayedCardsFacedown()
    }
  }
  
  //moves selected player cards to played cards area
  func setPlayedCards() {
    var i = 0
    for cardButton: UIButton in playedCards {
      i = playedCards.indexOf(cardButton)!
      
      //set game.playedCards contents' to display in playedCard area
      cardButton.setTitle(game.playedCards[i].contents, forState: UIControlState.Normal)
      
      //if no playedCard at index, then make invisible
      if(game.playedCards[i].contents == "") { //if no played card in this position
        cardButton.layer.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1).CGColor
        cardButton.layer.borderWidth = 0
      }
      //otherwise set card background
      else {
        cardButton.layer.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).CGColor
        cardButton.layer.borderWidth = 1
      }
    }
  }
  
  func setPlayedCardsFacedown() {
    //flip cards face down for next player
    if(!facedown) {
      for cardButton: UIButton in cardButtons {
        cardButton.setTitle("", forState: UIControlState.Normal)
        cardButton.setBackgroundImage(UIImage(named: "Card Back"), forState: UIControlState.Normal)
      }
      facedown = !facedown
    }
  }
  
  func titleForCard(card: Card) -> NSString {
    return facedown ? card.contents : ""
  }
  
  func unselectCards() {
    for cardButton: UIButton in cardButtons {
      let i = cardButtons.indexOf(cardButton)!
      cardButton.layer.borderWidth = 1
      cardButton.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha: 1).CGColor
      game.players[game.playerIndex].hand[i].selected = false
    }
  }
  
  func updatePassedList() {
    if(game.numPassed > 2) {
      passedList.text? = "Players who have passed: "
    }
    else { passedList.text? += "\n" + game.players[game.playerIndex].name!
    }
  }
  
//-- ALERT MESSAGES --//
  func alertMustBeginNewRound() {
    let alertView = UIAlertController(title: "Must play card(s)", message: "You cannot pass, you must start the new round.", preferredStyle: .Alert)
    alertView.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func alertMustSelectCards() {
    let alertView = UIAlertController(title: "Must select card(s)", message: "You didn't select any cards. Either select cards to play or press \"PASS\" if you want to skip your turn.", preferredStyle: .Alert)
    alertView.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
  
  func alertWinner() {
    let alertView = UIAlertController(title: game.players[game.playerIndex].name! + " Wins!", message: "Press \"BACK\" to start a new game or continue playing.", preferredStyle: .Alert)
    alertView.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
    presentViewController(alertView, animated: true, completion: nil)
  }
}