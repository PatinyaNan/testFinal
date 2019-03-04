//
//  ViewController.swift
//  finalMultipleSql
//
//  Created by Admin on 4/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    let fileName = "db.sqlite"
    let fileManager = FileManager .default
    var dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    var datePicker:UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()

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
        sql = "CREATE TABLE IF NOT EXISTS people " +
            "(id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "name TEXT, " +
            "date TEXT, " +
        "phone TEXT)"
        let createTb = sqlite3_exec(db, sql, nil, nil, nil)
        if createTb != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db))
            print(err)
        }

        sql = "INSERT INTO people (id, name, date, phone) VALUES " +
            "('1', 'สมชาย พายเรือ', '12/07/1998', '0812342XXX'), " +
            "('2', 'สมหญิง พายเรือ', '12/07/1998', '0812342XXX'), " +
            "('3', 'สมศรี พายเรือ', '12/07/1998', '0812342XXX'), " +
        "('4', 'สมกด พายเรือ', '12/07/1998', '0812342XXX')"
        sqlite3_exec(db, sql, nil, nil, nil)
        select()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func select() {
        sql = "SELECT * FROM people"
        sqlite3_prepare(db, sql, -1, &pointer, nil)
        textView.text = ""
        var id: Int32
        var name: String
        var date: String
        var phone: String

        while(sqlite3_step(pointer) == SQLITE_ROW) {
            id = sqlite3_column_int(pointer, 0)
            textView.text?.append("id: \(id)\n")

            name = String(cString: sqlite3_column_text(pointer, 1))
            textView.text?.append("name: \(name)\n")

            date = String(cString: sqlite3_column_text(pointer, 2))
            textView.text?.append("date: \(date)\n")

            phone = String(cString: sqlite3_column_text(pointer, 3))
            textView.text?.append("phone: \(phone)\n\n")
        }
    }
}

