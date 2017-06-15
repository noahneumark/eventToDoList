//
//  EventTableViewController.swift
//  eventsOpD
//
//  Created by Noah Neumark on 4/20/17.
//  Copyright © 2017 Noah Neumark. All rights reserved.
//

import UIKit
import CoreData

class EventTableViewController: UITableViewController, addEventDelegate {
    
    let sectionName = ["Incomplete", "Complete"]
    var incEvents = [Event]()
    var comEvents = [Event]()

    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int?
        if section == 0 {
            rows = incEvents.count
        } else {
            rows = comEvents.count
        }
        return rows!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        vc.delegate = self
        if segue.identifier == "editSegue" {
            vc.itemToUpdate = sender as? Event
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if indexPath.section == 0 {
            let dateString = dateFormatter.string(from: incEvents[indexPath.row].date! as Date)
            cell.textLabel?.text = "\(dateString) \(String(describing: incEvents[indexPath.row].title!))"
        } else {
            let dateString = dateFormatter.string(from: comEvents[indexPath.row].date! as Date)
            cell.textLabel?.text = "\(dateString) \(String(describing: comEvents[indexPath.row].title!))"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            incEvents[indexPath.row].complete = true
            print(indexPath.row)
        } else {
            comEvents[indexPath.row].complete = false
        }
        saveMOC()
        fetchAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if indexPath.section == 0 {
                let item = self.incEvents[indexPath.row]
                self.moc.delete(item)
            } else {
                let item = self.comEvents[indexPath.row]
                self.moc.delete(item)
            }
            self.saveMOC()
            self.fetchAll()
            tableView.reloadData()
        }

        if indexPath.section == 0 {
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                self.performSegue(withIdentifier: "editSegue", sender: self.incEvents[indexPath.row])
            }
            edit.backgroundColor = UIColor.blue
            return [delete, edit]
        } else {
            return [delete]
        }
    }

    func saveEvent() {
        self.navigationController?.popViewController(animated: true)
        fetchAll()
        tableView.reloadData()
    }
    
    func cancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchAll(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        do {
            let result = try moc.fetch(request)
            let resultArray = result as! [Event]
            incEvents = [Event]()
            comEvents = [Event]()

            for item in resultArray {
                if item.complete == false {
                    incEvents.append(item)
                } else {
                    comEvents.append(item)
                }
            }
            incEvents.sort(by: { $0.date?.compare($1.date! as Date) == ComparisonResult.orderedAscending })
            comEvents.sort(by: { $0.date?.compare($1.date! as Date) == ComparisonResult.orderedAscending })
        } catch {
            print(error)
        }
    }
    
    func saveMOC() {
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }

}
