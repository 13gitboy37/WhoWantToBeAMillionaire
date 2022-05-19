//
//  MainMenu.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 13.05.2022.
//

import UIKit

class MainMenu: UIViewController {

    @IBOutlet weak var lastResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastResultLabel.isHidden = true
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "startGameSegue":
            guard let destination = segue.destination as? GameVC else { return }
            destination.gameDelegate = self
            Game.gameSession.clearGameSession()
        default:
            break
        }
    }
}

extension MainMenu: GameVCDelegate {
    func didEndGame(withResult result: String) {
        lastResultLabel.isHidden = false
        self.lastResultLabel.text = "Последний результат: \(result)"
    }
}
