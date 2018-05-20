//
//  ViewController.swift
//  Plain Notes
//
//  Created by kieran waugh on 20/05/2018.
//  Copyright © 2018 Kieran Waugh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var table: UITableView!
    var data:[String] = []
    var fileURl:URL!
    var selectedRow:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
        table.delegate = self
        self.title = "Notes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        let baseURl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        fileURl = baseURl.appendingPathComponent("notes.txt")
        load()
    }
    
    @objc func addNote(){
        if table.isEditing {
            return
        }
        let name:String = "Item \(data.count + 1)"
        data.insert(name, at: 0)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell:UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .automatic)
        save()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        selectedRow = table.indexPathForSelectedRow!.row
        detailView.setText(t: data[selectedRow])
    }
    
    func save() {
       //UserDefaults.standard.set(data, forKey: "notes")
        let a = NSArray(array: data)
        do {
            try a.write(to: fileURl)
        } catch  {
            print("error writing file")
        }
    }
    
    func load(){
        if let loadedData:[String] = NSArray(contentsOf: fileURl) as? [String] {
            data = loadedData
            table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

