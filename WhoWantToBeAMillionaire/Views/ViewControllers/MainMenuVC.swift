//
//  MainMenu.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 13.05.2022.
//

import UIKit

class MainMenuVC: UIViewController {

    @IBOutlet weak var lastResultLabel: UILabel!
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    
    private var selectedDifficulty: Difficulty {
        switch self .difficultyControl.selectedSegmentIndex {
        case 0:
            return .easy
        case 1:
            return .medium
        default:
            return .medium
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastResultLabel.isHidden = true
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "startGameSegue":
            guard let destination = segue.destination as? GameVC else { return }
            destination.difficulty = selectedDifficulty
            destination.gameDelegate = self
            Game.gameSession.clearGameSession()
        default:
            break
        }
    }
}

extension MainMenuVC: GameVCDelegate {
    func didEndGame(withResult result: String) {
        lastResultLabel.isHidden = false
        self.lastResultLabel.text = "Последний результат: \(result)"
    }
}
