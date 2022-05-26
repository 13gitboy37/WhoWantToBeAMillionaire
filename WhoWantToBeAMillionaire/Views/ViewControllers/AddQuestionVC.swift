//
//  AddQuestion.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 22.05.2022.
//

import UIKit

class AddQuestionVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Private properties
    private var numbOfRows = 1
    private var caretaker = Caretaker()
    
    //MARK: - Properties
    var questionsAndAnswers = Game.shared.questions
    var questions = [Questions]() {
        didSet {
            caretaker.saveQuestions(questions: self.questions)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AddQuestionCell", bundle: nil), forCellReuseIdentifier: "addQuestionCell")
    }
    //MARK: - IBActions
    @IBAction func exitToMainMenu() {
        dismiss(animated: true)
    }
    
    @IBAction func insertSectionTap() {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: numbOfRows, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        numbOfRows += 1
        tableView.endUpdates()
    }
    
    @IBAction func addQuestionsTap() {
        questions.forEach { questionAndAnswers in
            Game.shared.questions.append(questionAndAnswers)
        }
        let alert = UIAlertController(title: "Добавление вопросов", message: "Вопросы добавлены. Нажмите ОК для выхода в главное меню", preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(alertOK)
        present(alert, animated: true)
    }
}

//MARK: - Extensions
extension AddQuestionVC: UITableViewDelegate {
    
}

extension AddQuestionVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numbOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addQuestionCell", for: indexPath) as? AddQuestionCell
        else { return UITableViewCell() }
        cell.delegateCell = self
        return cell
    }
}

extension AddQuestionVC: AddQuestionCellDelegate {
    func getQuestion(question: Questions) {
        self.questions.append(question)
    }
}
