//
//  ViewController.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 13.05.2022.
//

import UIKit

class GameVC: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var fiftyFiftyButton: UIButton!
    @IBOutlet weak var callFriendButton: UIButton!
    @IBOutlet weak var hallHelpButton: UIButton!
    
    private let question = Questions()
    private var indexQuestion = 0
    
    weak var gameDelegate: GameVCDelegate?
    var gameSessionDelegate = Game.gameSession
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestionAndAnswers(indexQuestion: indexQuestion)
    }
    
    func setQuestionAndAnswers(indexQuestion: Int) {
        answer1.isHidden = false
        answer2.isHidden = false
        answer3.isHidden = false
        answer4.isHidden = false
        let answers = question.answers[indexQuestion]
        if indexQuestion < question.question.count - 1 {
            questionLabel.text = question.question[indexQuestion]
            answer1.setTitle(answers?[0], for: .normal)
            answer2.setTitle(answers?[1], for: .normal)
            answer3.setTitle(answers?[2], for: .normal)
            answer4.setTitle(answers?[3], for: .normal)
        } else {
            endGame()
        }
    }
    
    @IBAction func tapAnswers(_ sender: UIButton) {
        if sender.titleLabel?.text == question.correctAnswer[indexQuestion] {
            sender.backgroundColor = .green
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                sender.backgroundColor = .systemGray6
                self.indexQuestion += 1
                self.setQuestionAndAnswers(indexQuestion: self.indexQuestion)
                gameSessionDelegate.rightAnswer = indexQuestion
                gameSessionDelegate.allQuestion = question.question.count
            }
        } else {
            sender.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sender.backgroundColor = .systemGray6
                self.endGame()
            }
        }
    }
    
    @IBAction func touchHelpButton(_ sender: Any) {
        setAlertController(title: "Зал подсказывает", message: "Правильный ответ \(question.correctAnswer[indexQuestion])")
        hallHelpButton.isHidden = true
        gameSessionDelegate.tapHallHelp = true
    }
    
    @IBAction func touchCallFriendButton(_ sender: Any) {
        setAlertController(title: "Друг подсказывает", message: "Правильный ответ \(question.correctAnswer[indexQuestion])")
        callFriendButton.isHidden = true
        gameSessionDelegate.tapCallFriend = true
    }
    
    @IBAction func touchFiftyFiftyButton(_ sender: Any) {
        if answer1.titleLabel?.text == question.correctAnswer[indexQuestion] {
            hideButtonForfiftyFifty(button1: answer2, button2: answer4)
        } else if answer2.titleLabel?.text == question.correctAnswer[indexQuestion] {
            hideButtonForfiftyFifty(button1: answer1, button2: answer4)
        } else if answer3.titleLabel?.text == question.correctAnswer[indexQuestion] {
            hideButtonForfiftyFifty(button1: answer2, button2: answer4)
        } else if answer4.titleLabel?.text == question.correctAnswer[indexQuestion] {
            hideButtonForfiftyFifty(button1: answer1, button2: answer2)
        }
        
        fiftyFiftyButton.isHidden = true
        gameSessionDelegate.tapFiftyFifty = true
    }
    
    @IBAction func exitToMainMenu(_ sender: Any) {
        let rightAnswers = self.indexQuestion
        let score = "\(rightAnswers * 100)$"
        let alertController = UIAlertController(title: "Выход", message: "Вы действительно хотите закончить игру и забрать \(score)", preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.endGame()
            self.dismiss(animated: true)
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        present(alertController, animated: true)
    }
    
    private func setAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(alertOK)
        present(alertController, animated: true, completion: nil)
    }
    
    private func hideButtonForfiftyFifty(button1: UIButton, button2: UIButton) {
        button1.isHidden = true
        button2.isHidden = true
    }
    
    private func endGame() {
        let rightAnswers = self.indexQuestion
        let score = "\(rightAnswers * 100)$"
        gameSessionDelegate.howMoneyWin = score
        let percentRightAnswer = (rightAnswers * 100) / question.question.count
        let record = Record(date: Date(), score: "\(percentRightAnswer)%")
        Game.shared.addRecord(record)
        self.gameDelegate?.didEndGame(withResult: "\(percentRightAnswer)%")
        self.dismiss(animated: true)
    }
}

protocol GameVCDelegate : AnyObject {
    func didEndGame(withResult result: String)
}
