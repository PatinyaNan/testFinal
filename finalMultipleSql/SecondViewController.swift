//
//  SecondViewController.swift
//  finalMultipleSql
//
//  Created by Admin on 4/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3
class SecondViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var selectDate: UIDatePicker!
    let fileName = "db.sqlite"
    let fileManager = FileManager .default
    var dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    @IBAction func insertData(_ sender: Any) {
        let name = nameText.text! as NSString
        let date = phoneText.text! as NSString
        let phone = phoneText.text! as NSString
        let currentDate = selectDate.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "YYYY-MM-dd"
        let thaiLocale = NSLocale(localeIdentifier: "TH_th")
        myFormatter.locale = thaiLocale as Locale!
        let currentDateText = myFormatter.string(from: currentDate)
        self.sql = "INSERT INTO people VALUES (null, ?, ?, ?)"
                    sqlite3_prepare(self.db, self.sql, -1, &self.stmt, nil)
                    sqlite3_bind_text(self.stmt, 1, name.utf8String, -1, nil)
                    sqlite3_bind_text(self.stmt, 2, currentDateText, -1, nil)
                    sqlite3_bind_text(self.stmt, 3, phone.utf8String, -1, nil)
                    sqlite3_step(self.stmt)
        
        //            self.select()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let dbURL = try! fileManager .url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(fileName)
        
        let opendb = sqlite3_open(dbURL.path, &db)
        if opendb != SQLITE_OK {
            print("Opening Database Error")
            return
        }
        else {
            print("Opening Database")
        }
    }
}
