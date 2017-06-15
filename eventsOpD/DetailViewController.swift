//
//  ViewController.swift
//  eventsOpD
//
//  Created by Noah Neumark on 4/20/17.
//  Copyright © 2017 Noah Neumark. All rights reserved.
//

import UIKit
import CoreData



class DetailViewController: UIViewController {
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate : addEventDelegate?
    var itemToUpdate: Event?
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var infoLabel: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if (itemToUpdate == nil){
            let myitem = NSEntityDescription.insertNewObject(forEntityName: "Event", into: moc) as! Event
            myitem.title = titleLabel.text
            myitem.info = infoLabel.text
            myitem.date = datePicker.date as NSDate
            myitem.complete = false
            saveMOC()
        } else {
            itemToUpdate?.title = titleLabel.text
            itemToUpdate?.info = infoLabel.text
            itemToUpdate?.date = datePicker.date as NSDate
            saveMOC()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.cancelButton()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (itemToUpdate != nil) {
            titleLabel.text = itemToUpdate?.title
            infoLabel.text = itemToUpdate?.info
            if let mydate = itemToUpdate?.date {
                datePicker.date = mydate as Date
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveMOC() {
        do {
            try moc.save()
            delegate?.saveEvent()
        } catch {
            print(error)
        }
    }



}

