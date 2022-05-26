//
//  Questions.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 18.05.2022.
//

import Foundation

struct Questions: Codable {
    var question: String
    var answers: [String]
    var correctAnswer: String
}

class QuestionsBuilder {
    
//MARK: - Properties
    var question = String()
    var answers =  [String]()
    var correctAnswer = String()
    
//MARK: - Methods 
    func build() -> Questions {
        return Questions(question: question, answers: answers, correctAnswer: correctAnswer)
    }

    func setQuestion(_ question: String) {
        self.question = question
    }

    func setAnswers(_ answers: [String]) {
        answers.forEach { answer in
            self.answers.append(answer)
        }
    }

    func setCorrectAnswers(_ correctAnswers: String) {
        self.correctAnswer = correctAnswers
    }

}
