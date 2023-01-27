//
//  CalendarViewController.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 5/12/2564 BE.
//

import UIKit
import FSCalendar
import GRDB

class CalendarViewController: UIViewController, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var defaults = UserDefaults.standard
    var user: [String] = []
    
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var txtView: UIView!
    @IBOutlet weak var txtMonth: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtDetail: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    
    var classId: [String] = []
    var imgNames: [String] = []
    var titles: [String] = []
    var workoutsYT: [String] = []
    var date1: [String] = []
    var time1: [String] = []
    var date2: [String] = []
    var time2: [String] = []
    var date3: [String] = []
    var time3: [String] = []
    var date4: [String] = []
    var time4: [String] = []
    
    var workoutsInSelectedDate: [String:[String]] = [:]
    
    var dbPath: String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    var selected = ""
    var selectedMonth = ""
    
    func loadTodayDateAndMonth() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        self.selected = formatter.string(from: now)
        formatter.dateFormat = "MMM"
        self.selectedMonth = formatter.string(from: now)
        self.txtDate.text = selected
        self.txtMonth.text = selectedMonth
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        self.selected = formatter.string(from: date)
        formatter.dateFormat = "MMM"
        self.selectedMonth = formatter.string(from: date)
        self.txtDate.text = selected
        self.txtMonth.text = selectedMonth
//        print(selected)
//        print(selectedMonth)
        
        workoutsInDate(date: date)
        self.txtDetail.text = "On this date, you have \(workoutsInSelectedDate["title"]!.count) workout(s)."
    }
    
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
                let rows = try Row.fetchCursor(db, sql: "select c.class_id , ct.picture_name name , c.video_name , c.date1 , c.time1 , c.date2 , c.time2 , c.date3 , c.time3 , c.date4 , c.time4 , ct.type_name from class c , class_type ct where c.ct_id = ct.ct_id")
                while let row = try rows.next() {
                    classId.append(row["class_id"])
                    titles.append(row["type_name"])
                    imgNames.append(row["name"])
                    workoutsYT.append(row["video_name"])
                    date1.append(row["date1"])
                    time1.append(row["time1"])
                    date2.append(row["date2"])
                    time2.append(row["time2"])
                    date3.append(row["date3"])
                    time3.append(row["time3"])
                    date4.append(row["date4"])
                    time4.append(row["time4"])
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func workoutsInDate(date: Date) {
        
        workoutsInSelectedDate = ["id": [], "title": [], "image": [], "youtube": [], "date": [], "time": []]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatted = dateFormatter.string(from: date)
        
        for i in 0..<date1.count {
            if date1[i] == formatted {
                workoutsInSelectedDate["id"]!.append(classId[i])
                workoutsInSelectedDate["title"]!.append(titles[i])
                workoutsInSelectedDate["image"]!.append(imgNames[i])
                workoutsInSelectedDate["youtube"]!.append(workoutsYT[i])
                workoutsInSelectedDate["date"]!.append(date1[i])
                workoutsInSelectedDate["time"]!.append(time1[i])
            }
            if date2[i] == formatted {
                workoutsInSelectedDate["id"]!.append(classId[i])
                workoutsInSelectedDate["title"]!.append(titles[i])
                workoutsInSelectedDate["image"]!.append(imgNames[i])
                workoutsInSelectedDate["youtube"]!.append(workoutsYT[i])
                workoutsInSelectedDate["date"]!.append(date2[i])
                workoutsInSelectedDate["time"]!.append(time2[i])
            }
            if date3[i] == formatted {
                workoutsInSelectedDate["id"]!.append(classId[i])
                workoutsInSelectedDate["title"]!.append(titles[i])
                workoutsInSelectedDate["image"]!.append(imgNames[i])
                workoutsInSelectedDate["youtube"]!.append(workoutsYT[i])
                workoutsInSelectedDate["date"]!.append(date3[i])
                workoutsInSelectedDate["time"]!.append(time3[i])
            }
            if date4[i] == formatted {
                workoutsInSelectedDate["id"]!.append(classId[i])
                workoutsInSelectedDate["title"]!.append(titles[i])
                workoutsInSelectedDate["image"]!.append(imgNames[i])
                workoutsInSelectedDate["youtube"]!.append(workoutsYT[i])
                workoutsInSelectedDate["date"]!.append(date4[i])
                workoutsInSelectedDate["time"]!.append(time4[i])
            }
        }
        
        workoutTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connect2DB()
        readDBitem()
        calendarView.delegate = self
        self.title = "Calendar"
        
        user = defaults.object(forKey: "savedUser") as! [String]

        calendarView.appearance.todayColor = .orange
        calendarView.appearance.titleTodayColor = .white
        calendarView.appearance.headerTitleColor = .orange
        calendarView.appearance.weekdayTextColor = .orange
        calendarView.appearance.titleWeekendColor = .red
        calendarView.appearance.selectionColor = .red
        
        loadTodayDateAndMonth()
        workoutsInDate(date: Date())
        
        self.txtView.layer.cornerRadius = 10
        self.workoutTableView.separatorStyle = .none
        self.imgBG.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutsInSelectedDate["title"]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "caldata", for: indexPath) as! CalendarTableViewCell
        cell.imgClass.image = UIImage.init(named: workoutsInSelectedDate["image"]![indexPath.row])
        cell.lbClass.text = workoutsInSelectedDate["title"]![indexPath.row]
        cell.lbTime.text = workoutsInSelectedDate["time"]![indexPath.row]
//        cell.imgTick.image = UIImage.init(systemName: "checkmark.square")
        cell.viewBlock.layer.cornerRadius = 10
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = workoutsInSelectedDate["id"]![indexPath.row]
        let memid = user[0]
        let histId = getHistoryId()
        let classDate = workoutsInSelectedDate["date"]![indexPath.row]
        
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
            print("added to History from Calendar")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let rowData = workoutTableView.indexPathForSelectedRow?.row
        if segue.identifier == "yt3" {
            let vc = segue.destination as! YTViewController
            vc.ytLink = workoutsInSelectedDate["youtube"]![rowData!]
        }
    }
    

}
