//
//  RecordsTableVC.swift
//  WhoWantToBeAMillionaire
//
//  Created by Никита Мошенцев on 14.05.2022.
//

import UIKit

class RecordsTableVC: UIViewController {
    
    @IBAction func exit (sender: Any) {
        dismiss(animated: true)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RecordsTableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Game.shared.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
        let record = Game.shared.records[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        cell.textLabel?.text = dateFormatter.string(from: record.date)
        cell.detailTextLabel?.text = "\(record.score)"
        return cell
    }
}
