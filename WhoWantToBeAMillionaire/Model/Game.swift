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
    static let shared = Game()
    
    private (set) var records: [Record] = [] {
        didSet {
            recordCaretaker.save(records: self.records)
        }
    }
    
    static let gameSession = GameSession()
    
    private let recordCaretaker = RecordsCaretaker()
    
    private init() {
        self.records = self.recordCaretaker.retrieveRecords()
    }
    func addRecord(_ record: Record) {
        self.records.append(record)
        Game.gameSession.clearGameSession()
    }
    
    func clearRecords() {
        self.records = []
    }
}
