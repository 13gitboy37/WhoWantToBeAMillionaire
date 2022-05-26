//
//  RecordsCaretaker.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 17.05.2022.
//

import UIKit

final class Caretaker {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "records"
    private let keyQuestions = "questions"
    
    func save(records: [Record]) {
        do {
            let data = try self.encoder.encode(records)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveRecords() -> [Record] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([Record].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
    
    func saveQuestions(questions: [Questions]) {
        do {
            let data = try self.encoder.encode(questions)
            UserDefaults.standard.set(data, forKey: keyQuestions)
        } catch {
            print(error)
        }
    }
    
    func retrieveQuestions() -> [Questions] {
        guard let data = UserDefaults.standard.data(forKey: keyQuestions) else {
            return []
        }
        do {
            return try self.decoder.decode([Questions].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
