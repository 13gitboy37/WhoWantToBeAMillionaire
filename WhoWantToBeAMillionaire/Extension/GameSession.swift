//
//  GameSession.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 14.05.2022.
//

import UIKit

class GameSession {
    var rightAnswer = 0
    var allQuestion = 0
    var tapCallFriend = false
    var tapHallHelp = false
    var tapFiftyFifty = false
    var howMoneyWin = ""
    var score = Observable<String>("")
    var numQuestion = Observable<Int>(0)

    func clearGameSession() {
        rightAnswer = 0
        howMoneyWin = ""
        tapFiftyFifty = false
        tapCallFriend = false
        tapHallHelp = false
        score.value = ""
        numQuestion.value = 0
    }
}
