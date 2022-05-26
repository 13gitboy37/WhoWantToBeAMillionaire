//
//  AddQuestionCell.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 22.05.2022.
//

import UIKit

class AddQuestionCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var rightAnswerTextField: UITextField!
    @IBOutlet weak var secondAnswerTextField: UITextField!
    @IBOutlet weak var thirdAnswerTextField: UITextField!
    @IBOutlet weak var fourthAnswerTextField: UITextField!
    
    //MARK: - Private properties
    private var builder = QuestionsBuilder()
    private var answers = [String]()
    
    //MARK: - Properties
    var delegateCell: AddQuestionCellDelegate?
    var question = Questions(question: "", answers: [""], correctAnswer: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - IBActions
    @IBAction func endEditingQuestionTF(_ sender: UITextField) {
        builder.setQuestion(sender.text ?? "")
        print(question.question)
    }
    
    @IBAction func endEditingCorrectAnswerTF(_ sender: UITextField) {
        builder.setCorrectAnswers(sender.text ?? "")
        answers.append(sender.text ?? "")
        print(question.correctAnswer)
    }
    
    @IBAction func endEditingAnswersTF(_ sender: UITextField) {
        answers.append(sender.text ?? "")
        if answers.count == 4 {
            builder.setAnswers(answers)
            question = builder.build()
            delegateCell?.getQuestion(question: question)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - Protocol
protocol AddQuestionCellDelegate {
    func getQuestion(question: Questions)
}
