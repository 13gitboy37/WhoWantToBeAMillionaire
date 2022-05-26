//
//  CreateQuestionStrategy.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 20.05.2022.
//

import Foundation

protocol SetQuestionStrategy {
    func setQuestionStrategy() -> [Int]
}

final class RandomSetQuestionStrategy: SetQuestionStrategy {
    func setQuestionStrategy() -> [Int] {
       var regularIndexQuestion = [Int]()
        for i in 0...Game.shared.questions.count - 1 {
            regularIndexQuestion.append(i)
        }
        var indexesQuestion = [Int]()
        indexesQuestion = regularIndexQuestion.shuffled()
        return indexesQuestion
    }
}

final class ConsistentSetQuestionStrategy: SetQuestionStrategy {
    func setQuestionStrategy() -> [Int] {
        var indexesQuestion = [Int]()
        for i in 0...Game.shared.questions.count - 1 {
            indexesQuestion.append(i)
        }
        return indexesQuestion
    }
}
