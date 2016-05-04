//
//  PlayerNameViewController.swift
//  Thirteen
//
//  Created by Kevin Largo on 1/13/16.
//  Copyright (c) 2016 xkevlar. All rights reserved.
//

import UIKit
import LocalAuthentication

class PlayerNameViewController: UIViewController {
  @IBOutlet var playerNames: [UITextField]!
  
  @IBAction func unwindToPlayerNameView(segue: UIStoryboardSegue) {
  }

  
  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    if(segue.identifier == "startSegue") {
      let gvc = segue!.destinationViewController as! ViewController
      
      var i = 0
      for nameField: UITextField in playerNames {
        i = playerNames.indexOf(nameField)!
        
        if(nameField.text != "") {
          gvc.playerNames[i] = nameField.text!
        }
        else {
          gvc.playerNames[i] = "Player " + String(i + 1)
        }
      }
    }
  }
}