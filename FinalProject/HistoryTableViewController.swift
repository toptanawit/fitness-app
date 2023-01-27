//
//  HistoryTableViewController.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 7/12/2564 BE.
//

import UIKit
import GRDB

class HistoryTableViewController: UITableViewController, UISearchBarDelegate {
    
    var dbPath: String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    var defaults = UserDefaults.standard
    var user: [String] = []
    
    @IBOutlet var historyTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var classId: [String] = []
    var workouts: [String] = []
    var workoutsImg: [String] = []
    var workoutsYT: [String] = []
    var trainers: [String] = []
    var workoutsTime1: [String] = []
    var workoutsDate1: [String] = []
    var workoutsTime2: [String] = []
    var workoutsDate2: [String] = []
    var workoutsTime3: [String] = []
    var workoutsDate3: [String] = []
    var workoutsTime4: [String] = []
    var workoutsDate4: [String] = []

    var all: [[String:[String]]] = []
    var history: [String:[String]] = [:]
    
    var allData: [String:[String]] = [:]
    
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
    
    func checkHistory() {
        
        history = ["hisid": [], "memid": [], "classid": [], "date": []]
        
        do {
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.inDatabase { db in
                let rows = try Row.fetchCursor(db, sql: "SELECT h.history_id , h.member_id , h.class_id , h.class_date FROM history h")
                while let row = try rows.next() {
                    history["hisid"]!.append(row["history_id"])
                    history["memid"]!.append(row["member_id"])
                    history["classid"]!.append(row["class_id"])
                    history["date"]!.append(row["class_date"])
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadAllData() {
        allData.updateValue(classId, forKey: "id")
        allData.updateValue(workouts, forKey: "title")
        allData.updateValue(workoutsImg, forKey: "image")
        allData.updateValue(workoutsYT, forKey: "youtube")
        allData.updateValue(trainers, forKey: "trainer")
        allData.updateValue(workoutsDate1, forKey: "date")
        allData.updateValue(workoutsTime1, forKey: "time")
        for i in 0..<35 {
            allData["id"]!.append(classId[i])
            allData["title"]!.append(workouts[i])
            allData["image"]!.append(workoutsImg[i])
            allData["youtube"]!.append(workoutsYT[i])
            allData["trainer"]!.append(trainers[i])
            allData["date"]!.append(workoutsDate2[i])
            allData["time"]!.append(workoutsTime2[i])
        }
        for i in 0..<35 {
            allData["id"]!.append(classId[i])
            allData["title"]!.append(workouts[i])
            allData["image"]!.append(workoutsImg[i])
            allData["youtube"]!.append(workoutsYT[i])
            allData["trainer"]!.append(trainers[i])
            allData["date"]!.append(workoutsDate3[i])
            allData["time"]!.append(workoutsTime3[i])
        }
        for i in 0..<35 {
            allData["id"]!.append(classId[i])
            allData["title"]!.append(workouts[i])
            allData["image"]!.append(workoutsImg[i])
            allData["youtube"]!.append(workoutsYT[i])
            allData["trainer"]!.append(trainers[i])
            allData["date"]!.append(workoutsDate4[i])
            allData["time"]!.append(workoutsTime4[i])
        }
        allData.updateValue(["Other Videos"], forKey: "type")
    }
    
    func loadDict() {
        
        checkHistory()
        
        all = [["type": ["Watched"], "id": [], "title": [], "image": [], "trainer": [], "date": [], "time": [], "youtube": []],["type": ["Others Video"], "id": [], "title": [], "image": [], "trainer": [], "date": [], "time": [], "youtube": []]]
        
        if !history["memid"]!.isEmpty {
            for i in 0..<classId.count {
                for j in 0..<history["memid"]!.count {
                    if classId[i] == history["classid"]![j] && workoutsDate1[i] == history["date"]![j] && user[0] == history["memid"]![j] {
                        all[0]["id"]!.append(classId[i])
                        all[0]["title"]!.append(workouts[i])
                        all[0]["image"]!.append(workoutsImg[i])
                        all[0]["youtube"]!.append(workoutsYT[i])
                        all[0]["trainer"]!.append(trainers[i])
                        all[0]["date"]!.append(workoutsDate1[i])
                        all[0]["time"]!.append(workoutsTime1[i])
                        
                    } else if classId[i] == history["classid"]![j] && workoutsDate2[i] == history["date"]![j] && user[0] == history["memid"]![j] {
                        all[0]["id"]!.append(classId[i])
                        all[0]["title"]!.append(workouts[i])
                        all[0]["image"]!.append(workoutsImg[i])
                        all[0]["youtube"]!.append(workoutsYT[i])
                        all[0]["trainer"]!.append(trainers[i])
                        all[0]["date"]!.append(workoutsDate2[i])
                        all[0]["time"]!.append(workoutsTime2[i])
                        
                    } else if classId[i] == history["classid"]![j] && workoutsDate3[i] == history["date"]![j] && user[0] == history["memid"]![j] {
                        all[0]["id"]!.append(classId[i])
                        all[0]["title"]!.append(workouts[i])
                        all[0]["image"]!.append(workoutsImg[i])
                        all[0]["youtube"]!.append(workoutsYT[i])
                        all[0]["trainer"]!.append(trainers[i])
                        all[0]["date"]!.append(workoutsDate3[i])
                        all[0]["time"]!.append(workoutsTime3[i])
                        
                    } else if classId[i] == history["classid"]![j] && workoutsDate4[i] == history["date"]![j] && user[0] == history["memid"]![j] {
                        all[0]["id"]!.append(classId[i])
                        all[0]["title"]!.append(workouts[i])
                        all[0]["image"]!.append(workoutsImg[i])
                        all[0]["youtube"]!.append(workoutsYT[i])
                        all[0]["trainer"]!.append(trainers[i])
                        all[0]["date"]!.append(workoutsDate4[i])
                        all[0]["time"]!.append(workoutsTime4[i])
                        
                    }
                }
            }
        }
        
        all[1] = allData
        all[0]["id"] = all[0]["id"]!.reversed()
        all[0]["title"] = all[0]["title"]!.reversed()
        all[0]["image"] = all[0]["image"]!.reversed()
        all[0]["youtube"] = all[0]["youtube"]!.reversed()
        all[0]["trainer"] = all[0]["trainer"]!.reversed()
        all[0]["date"] = all[0]["date"]!.reversed()
        all[0]["time"] = all[0]["time"]!.reversed()
        historyTableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        all = [["type": ["Watched"], "id": [], "title": [], "image": [], "trainer": [], "date": [], "time": [], "youtube": []],["type": ["Other Videos"], "id": [], "title": [], "image": [], "trainer": [], "date": [], "time": [], "youtube": []]]
        
        if searchText == "" {
            loadDict()
        }
        
        for i in 0..<workouts.count {
            if workouts[i].lowercased().contains(searchText.lowercased()) || workoutsDate1[i].lowercased().contains(searchText.lowercased()) || workoutsTime1[i].lowercased().contains(searchText.lowercased()) || trainers[i].contains(searchText.lowercased()) {
                all[1]["id"]!.append(classId[i])
                all[1]["title"]!.append(workouts[i])
                all[1]["image"]!.append(workoutsImg[i])
                all[1]["youtube"]!.append(workoutsYT[i])
                all[1]["trainer"]!.append(trainers[i])
                all[1]["date"]!.append(workoutsDate1[i])
                all[1]["time"]!.append(workoutsTime1[i])
            }
            if workouts[i].lowercased().contains(searchText.lowercased()) || workoutsDate2[i].lowercased().contains(searchText.lowercased()) ||           workoutsTime2[i].lowercased().contains(searchText.lowercased()) || trainers[i].contains(searchText.lowercased()) {
                all[1]["id"]!.append(classId[i])
                all[1]["title"]!.append(workouts[i])
                all[1]["image"]!.append(workoutsImg[i])
                all[1]["youtube"]!.append(workoutsYT[i])
                all[1]["trainer"]!.append(trainers[i])
                all[1]["date"]!.append(workoutsDate2[i])
                all[1]["time"]!.append(workoutsTime2[i])
            }
            if workouts[i].lowercased().contains(searchText.lowercased()) || workoutsDate3[i].lowercased().contains(searchText.lowercased()) || workoutsTime3[i].lowercased().contains(searchText.lowercased()) || trainers[i].contains(searchText.lowercased()) {
                all[1]["id"]!.append(classId[i])
                all[1]["title"]!.append(workouts[i])
                all[1]["image"]!.append(workoutsImg[i])
                all[1]["youtube"]!.append(workoutsYT[i])
                all[1]["trainer"]!.append(trainers[i])
                all[1]["date"]!.append(workoutsDate3[i])
                all[1]["time"]!.append(workoutsTime3[i])
            }
            if workouts[i].lowercased().contains(searchText.lowercased()) || workoutsDate4[i].lowercased().contains(searchText.lowercased()) || workoutsTime4[i].lowercased().contains(searchText.lowercased()) || trainers[i].contains(searchText.lowercased()) {
                all[1]["id"]!.append(classId[i])
                all[1]["title"]!.append(workouts[i])
                all[1]["image"]!.append(workoutsImg[i])
                all[1]["youtube"]!.append(workoutsYT[i])
                all[1]["trainer"]!.append(trainers[i])
                all[1]["date"]!.append(workoutsDate4[i])
                all[1]["time"]!.append(workoutsTime4[i])
            }
        }
        
        historyTableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.separatorStyle = .none
        self.title = "History"
        user = defaults.object(forKey: "savedUser") as! [String]
        connect2DB()
        readDBitem()
        loadAllData()
        loadDict()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDict()
        historyTableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let items = all[section]["title"] else {
            return 0
        }
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hsdata", for: indexPath) as! HistoryTableViewCell
        
        guard let itemTitles = all[indexPath.section]["title"] else {
            return cell
        }
        guard let itemTrainers = all[indexPath.section]["trainer"] else {
            return cell
        }
        guard let itemDate = all[indexPath.section]["date"] else {
            return cell
        }
        guard let itemTime = all[indexPath.section]["time"] else {
            return cell
        }
        guard let itemImg = all[indexPath.section]["image"] else {
            return cell
        }
        
        cell.txtClass.text = itemTitles[indexPath.row]
        cell.txtTrainer.text = itemTrainers[indexPath.row]
        cell.txtDate.text = itemDate[indexPath.row]
        cell.txtTime.text = itemTime[indexPath.row]
        cell.imgClass.image = UIImage.init(named: itemImg[indexPath.row])
        
        if indexPath.section == 0 {
            cell.tick.image = UIImage.init(systemName: "checkmark.square")
            cell.tick.layer.cornerRadius = 10
            cell.tick.isHidden = false
        } else {
            cell.tick.isHidden = true
        }
        
        cell.imgClass.layer.cornerRadius = 20
        cell.viewBlock.layer.cornerRadius = 20
        cell.viewBlock.layer.shadowColor = UIColor.gray.cgColor
        cell.viewBlock.layer.shadowOpacity = 1
        cell.viewBlock.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.viewBlock.layer.shadowRadius = 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return all[section]["type"]![0]
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
        
        let id = allData["id"]![indexPath.row]
        let memid = user[0]
        let histId = getHistoryId()
        let classDate = allData["date"]![indexPath.row]
        
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
            print("added to History from history")
        } catch {
            print(error.localizedDescription)
        }
        
        loadDict()
        historyTableView.reloadData()
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
        let rowData = self.historyTableView.indexPathForSelectedRow?.row
        if segue.identifier == "yt5" {
            let vc = segue.destination as! YTViewController
            vc.ytLink = allData["youtube"]![rowData!]
        }
    }
    

}
