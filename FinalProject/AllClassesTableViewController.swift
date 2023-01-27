//
//  AllClassesTableViewController.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 6/12/2564 BE.
//

import UIKit
import GRDB

class AllClassesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var dbPath: String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    var defaults = UserDefaults.standard
    var user: [String] = []
    
    @IBOutlet var allClassTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var workouts: [String] = []
    var workoutsImg: [String] = []
    var workoutsYT: [String] = []
    var trainers: [String] = []
    var classId: [String] = []
    var workoutsTime1: [String] = []
    var workoutsDate1: [String] = []
    var workoutsTime2: [String] = []
    var workoutsDate2: [String] = []
    var workoutsTime3: [String] = []
    var workoutsDate3: [String] = []
    var workoutsTime4: [String] = []
    var workoutsDate4: [String] = []

    var allClasses: [String:[String]] = [:]
    
    func connect2DB() {
        config.readonly = true
        do {
            dbPath = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Fitness.db")
            .path
            if !fileManager.fileExists(atPath: dbPath) {
                 dbResourcePath = Bundle.main.path(forResource: "Fitness", ofType: "db")!
                 try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
            }
         } catch {
             print("An error has occured")
         }
    }
    
    func readDBitem() {
        do {
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.inDatabase { db in
                let rows = try Row.fetchCursor(db, sql: "select c.* , ct.type_name from class c , class_type ct where c.ct_id = ct.ct_id")
                while let row = try rows.next() {
                    classId.append(row["class_id"])
                    workouts.append(row["type_name"])
                    workoutsImg.append(row["picture_name"])
                    workoutsYT.append(row["video_name"])
                    trainers.append(row["trainer"])
                    workoutsDate1.append(row["date1"])
                    workoutsDate2.append(row["date2"])
                    workoutsDate3.append(row["date3"])
                    workoutsDate4.append(row["date4"])
                    workoutsTime1.append(row["time1"])
                    workoutsTime2.append(row["time2"])
                    workoutsTime3.append(row["time3"])
                    workoutsTime4.append(row["time4"])
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadDict() {
        allClasses.updateValue(classId, forKey: "id")
        allClasses.updateValue(workouts, forKey: "title")
        allClasses.updateValue(workoutsImg, forKey: "image")
        allClasses.updateValue(workoutsYT, forKey: "youtube")
        allClasses.updateValue(trainers, forKey: "trainer")
        allClasses.updateValue(workoutsDate1, forKey: "date")
        allClasses.updateValue(workoutsTime1, forKey: "time")
        
        for i in 0..<35 {
            allClasses["id"]!.append(classId[i])
            allClasses["title"]!.append(workouts[i])
            allClasses["image"]!.append(workoutsImg[i])
            allClasses["youtube"]!.append(workoutsYT[i])
            allClasses["trainer"]!.append(trainers[i])
            allClasses["date"]!.append(workoutsDate2[i])
            allClasses["time"]!.append(workoutsTime2[i])
        }
        for i in 0..<35 {
            allClasses["id"]!.append(classId[i])
            allClasses["title"]!.append(workouts[i])
            allClasses["image"]!.append(workoutsImg[i])
            allClasses["youtube"]!.append(workoutsYT[i])
            allClasses["trainer"]!.append(trainers[i])
            allClasses["date"]!.append(workoutsDate3[i])
            allClasses["time"]!.append(workoutsTime3[i])
        }
        for i in 0..<35 {
            allClasses["id"]!.append(classId[i])
            allClasses["title"]!.append(workouts[i])
            allClasses["image"]!.append(workoutsImg[i])
            allClasses["youtube"]!.append(workoutsYT[i])
            allClasses["trainer"]!.append(trainers[i])
            allClasses["date"]!.append(workoutsDate4[i])
            allClasses["time"]!.append(workoutsTime4[i])
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        allClasses = ["id": [], "title": [], "image": [], "youtube": [], "trainer": [], "date": [], "time": []]
        
        if searchText == "" {
            loadDict()
        }
        
        for i in 0..<workouts.count {
            if workouts[i].lowercased().contains(searchText.lowercased()) || workoutsDate1[i].lowercased().contains(searchText.lowercased()) || workoutsTime1[i].lowercased().contains(searchText.lowercased()) || trainers[i].contains(searchText.lowercased()) {
                allClasses["id"]!.append(classId[i])
                allClasses["title"]!.append(workouts[i])
                allClasses["image"]!.append(workoutsImg[i])
                allClasses["youtube"]!.append(workoutsYT[i])
                allClasses["trainer"]!.append(trainers[i])
                allClasses["date"]!.append(workoutsDate1[i])
                allClasses["time"]!.append(workoutsTime1[i])
            }
            if workouts[i].lowercased().contains(searchText.lowercased()) || workoutsDate2[i].lowercased().contains(searchText.lowercased()) ||           workoutsTime2[i].lowercased().contains(searchText.lowercased()) || trainers[i].contains(searchText.lowercased()) {
                allClasses["id"]!.append(classId[i])
                allClasses["title"]!.append(workouts[i])
                allClasses["image"]!.append(workoutsImg[i])
                allClasses["youtube"]!.append(workoutsYT[i])
                allClasses["trainer"]!.append(trainers[i])
                allClasses["date"]!.append(workoutsDate2[i])
                allClasses["time"]!.append(workoutsTime2[i])
            }
            if workouts[i].lowercased().contains(searchText.lowercased()) || workoutsDate3[i].lowercased().contains(searchText.lowercased()) || workoutsTime3[i].lowercased().contains(searchText.lowercased()) || trainers[i].contains(searchText.lowercased()) {
                allClasses["id"]!.append(classId[i])
                allClasses["title"]!.append(workouts[i])
                allClasses["image"]!.append(workoutsImg[i])
                allClasses["youtube"]!.append(workoutsYT[i])
                allClasses["trainer"]!.append(trainers[i])
                allClasses["date"]!.append(workoutsDate3[i])
                allClasses["time"]!.append(workoutsTime3[i])
            }
            if workouts[i].lowercased().contains(searchText.lowercased()) || workoutsDate4[i].lowercased().contains(searchText.lowercased()) || workoutsTime4[i].lowercased().contains(searchText.lowercased()) || trainers[i].contains(searchText.lowercased()) {
                allClasses["id"]!.append(classId[i])
                allClasses["title"]!.append(workouts[i])
                allClasses["image"]!.append(workoutsImg[i])
                allClasses["youtube"]!.append(workoutsYT[i])
                allClasses["trainer"]!.append(trainers[i])
                allClasses["date"]!.append(workoutsDate4[i])
                allClasses["time"]!.append(workoutsTime4[i])
            }
        }
        
        allClassTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allClassTableView.separatorStyle = .none
        self.title = "All Classes"
        connect2DB()
        readDBitem()
        loadDict()
        
        user = defaults.object(forKey: "savedUser") as! [String]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allClasses["title"]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "acdata", for: indexPath) as! AllClassesTableViewCell
        cell.imgClass.image = UIImage.init(named: allClasses["image"]![indexPath.row])
        cell.txtClass.text = allClasses["title"]![indexPath.row]
        cell.txtTrainer.text = "by " + allClasses["trainer"]![indexPath.row]
        cell.txtDate.text = allClasses["date"]![indexPath.row]
        cell.txtTime.text = allClasses["time"]![indexPath.row]
        
//        cell.tick.image = UIImage.init(systemName: "checkmark.square")
        
        cell.viewBlock.layer.cornerRadius = 20
        cell.imgClass.layer.cornerRadius = 20
        cell.viewBlock.layer.shadowColor = UIColor.gray.cgColor
        cell.viewBlock.layer.shadowOpacity = 1
        cell.viewBlock.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.viewBlock.layer.shadowRadius = 2
        
        return cell
    }
    
    func getHistoryId() -> String {
        var temp: Int? = 0
        do {
        let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.inDatabase { db in
                let rows = try Int.fetchOne(db, sql: "SELECT count(history_id)+1 FROM history")
                temp = rows!
            }
        } catch {
            print(error.localizedDescription)
        }
        return temp!.description
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = allClasses["id"]![indexPath.row]
        let memid = user[0]
        let histId = getHistoryId()
        let classDate = allClasses["date"]![indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let watchDate = formatter.string(from: Date())
        formatter.dateFormat = "HH:mm"
        let watchTime = formatter.string(from: Date())
        
        do {
            config.readonly=false
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.write { db in
                try db.execute(sql: "INSERT INTO history (history_id,member_id,class_id,watch_date,watch_time,class_date) VALUES (?, ?, ?, ?, ?, ?)", arguments: [histId, memid, id, watchDate, watchTime, classDate])
            }
            print("added to History from all classes")
        } catch {
            print(error.localizedDescription)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let rowData = self.allClassTableView.indexPathForSelectedRow?.row
        if segue.identifier == "yt4" {
            let vc = segue.destination as! YTViewController
            vc.ytLink = allClasses["youtube"]![rowData!]
        }
    }
    

}
