//
//  ViewController.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 13.05.2022.
//

import UIKit

class GameVC: UIViewController {
    //MARK: - IBOutlet`s
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var fiftyFiftyButton: UIButton!
    @IBOutlet weak var callFriendButton: UIButton!
    @IBOutlet weak var hallHelpButton: UIButton!
    @IBOutlet weak var numberQuestionLabel: UILabel!
    @IBOutlet weak var progressGameLabel: UILabel!
    
    //MARK: - Private properties
    private var question = Game.shared.questions
    private var indexQuestion = 0
    private var setQuestionStrategy: SetQuestionStrategy {
        switch self.difficulty{
        case .easy:
            return ConsistentSetQuestionStrategy()
        case .medium:
            return RandomSetQuestionStrategy()
        }
    }
    private var indexesQuestions = [Int]()
    
    //MARK: - Properties
    weak var gameDelegate: GameVCDelegate?
    var gameSessionDelegate = Game.gameSession
    var difficulty: Difficulty = .medium
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexesQuestions = setQuestionStrategy.setQuestionStrategy()
        setQuestionAndAnswers(indexQuestion: indexQuestion)
        let percentRightAnswer = (setScore(indexQuestion: indexQuestion) * 100) / question.count
        gameSessionDelegate.numQuestion.value = self.indexQuestion
        gameSessionDelegate.score.value = "\(percentRightAnswer)%"
        gameSessionDelegate.score.addObserver(self, options: [.new, .initial]) { [weak self] (score,_ ) in
            self?.progressGameLabel.text = "Вы прошли \(score) от всех вопросов"
        }
        gameSessionDelegate.numQuestion.addObserver(self, options: [.new, .initial]) { [weak self] (numQuestion,_ ) in
            let numberQuestion = numQuestion + 1
            self?.numberQuestionLabel.text = "Номер текущего вопроса \(numberQuestion)"
        }
    }
    
    //MARK: - IBAction`s
    @IBAction func tapAnswers(_ sender: UIButton) {
        if sender.titleLabel?.text == question[indexesQuestions[indexQuestion]].correctAnswer {
            sender.backgroundColor = .green
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                sender.backgroundColor = .systemGray6
                self.indexQuestion += 1
                self.setQuestionAndAnswers(indexQuestion: self.indexQuestion)
                gameSessionDelegate.rightAnswer = indexQuestion
                gameSessionDelegate.allQuestion = question.count
                let percentRightAnswer = (setScore(indexQuestion: indexQuestion) * 100) / question.count
                gameSessionDelegate.numQuestion.value = self.indexQuestion
                gameSessionDelegate.score.value = "\(percentRightAnswer)%"
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
        setAlertController(title: "Зал подсказывает", message: "Наибольшее колличество голосов за ответ: \(question[indexesQuestions[indexQuestion]].correctAnswer)")
        hallHelpButton.isHidden = true
        gameSessionDelegate.tapHallHelp = true
    }
    
    @IBAction func touchCallFriendButton(_ sender: Any) {
        setAlertController(title: "Друг подсказывает", message: "Правильный ответ \(question[indexesQuestions[indexQuestion]].correctAnswer)")
        callFriendButton.isHidden = true
        gameSessionDelegate.tapCallFriend = true
    }
    
    @IBAction func touchFiftyFiftyButton(_ sender: Any) {
        if answer1.titleLabel?.text == question[indexesQuestions[indexQuestion]].correctAnswer {
            hideButtonForfiftyFifty(button1: answer2, button2: answer4)
        } else if answer2.titleLabel?.text == question[indexesQuestions[indexQuestion]].correctAnswer {
            hideButtonForfiftyFifty(button1: answer1, button2: answer4)
        } else if answer3.titleLabel?.text == question[indexesQuestions[indexQuestion]].correctAnswer {
            hideButtonForfiftyFifty(button1: answer2, button2: answer4)
        } else if answer4.titleLabel?.text == question[indexesQuestions[indexQuestion]].correctAnswer {
            hideButtonForfiftyFifty(button1: answer1, button2: answer2)
        }
        
        fiftyFiftyButton.isHidden = true
        gameSessionDelegate.tapFiftyFifty = true
    }
    
    @IBAction func exitToMainMenu(_ sender: Any) {
        let score = "\(setScore(indexQuestion: indexQuestion) * 100)$"
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
    //MARK: - Private methods
    private func setQuestionAndAnswers(indexQuestion: Int) {
        answer1.isHidden = false
        answer2.isHidden = false
        answer3.isHidden = false
        answer4.isHidden = false
        if indexQuestion < question.count {
            let answers = question[indexesQuestions[indexQuestion]].answers.shuffled()
            questionLabel.text = question[indexesQuestions[indexQuestion]].question
            answer1.setTitle(answers[0], for: .normal)
            answer2.setTitle(answers[1], for: .normal)
            answer3.setTitle(answers[2], for: .normal)
            answer4.setTitle(answers[3], for: .normal)
        } else {
            endGame()
        }
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
        let percentRightAnswer = (setScore(indexQuestion: indexQuestion) * 100) / question.count
        let record = Record(date: Date(), score: "\(percentRightAnswer)%")
        Game.shared.addRecord(record)
        self.gameDelegate?.didEndGame(withResult: "\(percentRightAnswer)%")
        self.dismiss(animated: true)
    }
    
    private func setScore(indexQuestion: Int) -> Int {
        let rightAnswers = indexQuestion
        let score = "\(rightAnswers * 100)$"
        gameSessionDelegate.howMoneyWin = score
        return rightAnswers
    }
}
//MARK: - Protocol
protocol GameVCDelegate : AnyObject {
    func didEndGame(withResult result: String)
}
