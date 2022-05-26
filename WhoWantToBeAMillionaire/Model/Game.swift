//
//  Game.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 14.05.2022.
//

import UIKit

struct Record: Codable {
    let date: Date
    let score: String
}

final class Game {
    
   //MARK: - Static properties
    static let shared = Game()
    static let gameSession = GameSession()
    
    var questions: [Questions] = [
        Questions(question: "Какую фамилию носил главный герой поэмы                                                  А. Твардовского?",
                  answers:["Петров", "Тёркин", "Иванов", "Андреев"],
                  correctAnswer: "Тёркин"),
        Questions(question:  "В песне какого барда есть строчка: 'Лыжи у печки стоят...' ?",
                  answers: ["Владимир Высоцкий", "Виктор Цой", "Булат Окуджава","Юрий Визбор"],
                  correctAnswer: "Юрий Визбор"),
        Questions(question: "Что в конце XIX века было основным товаром на Лубянской площади в Москве во время Введенской ярмарки?",
                  answers: ["Сани", "Клюшка", "Коньки","Ведро"],
                  correctAnswer: "Сани"),
        Questions(question:  "Какой советский космонавт получил первую космическую почту?",
                  answers: ["Владимир Шаталов", "Герман Титов", "Юрий Гагарин","Валентина Терешкова"],
                  correctAnswer: "Владимир Шаталов"),
        Questions(question: "Как называют звезду, которая указала волхвам место рождения Христа?",
                  answers: ["Иерусалимская", "Вифлеемская", "Полярная","Московская"],
                  correctAnswer: "Вифлеемская"),
        Questions(question: "Где, если верить пословице, любопытной Варваре нос оторвали?",
                  answers: ["На параде", "В бане", "В парадной","На базаре"],
                  correctAnswer: "На базаре"),
        Questions(question: "Как называют период времени, когда солнце в северных широтах не опускается за горизонт?",
                  answers: ["Солнечный день", "Солнечная ночь", "Полярный день","Полярная ночь"],
                  correctAnswer: "Полярный день"),
        Questions(question: "Кто автор проекта радиобашни на Шаболовке?",
                  answers: ["Матвей Дынкин", "Эрнест Быков", "Владимир Шухов","Евгений Замятин"],
                  correctAnswer: "Владимир Шухов"),
        Questions(question: "За чем послала жена мужа в мультфильме Падал прошлогодний снег?",
                  answers: ["За углём", "За ёлкой", "За спичками","За ведром"],
                  correctAnswer: "За ёлкой"),
        Questions(question: "Какой знак восточного гороскопа следует за знаком Дракона?",
                  answers: ["Собака", "Еж", "Тигр","Змея"],
                  correctAnswer: "Змея")]

    static let questionBuilder = QuestionsBuilder()
    
    //MARK: - Private properties
    private (set) var records: [Record] = [] {
        didSet {
            caretaker.save(records: self.records)
        }
    }
    
    private let caretaker = Caretaker()
    
    //MARK: - Init
    private init() {
        self.records = self.caretaker.retrieveRecords()
        self.caretaker.retrieveQuestions().forEach { question in
            self.questions.append(question)
        }
    }
    
    //MARK: - Methods
    func addRecord(_ record: Record) {
        self.records.append(record)
        Game.gameSession.clearGameSession()
    }
    
    func clearRecords() {
        self.records = []
    }
}
