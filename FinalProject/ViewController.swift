//
//  ViewController.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 4/12/2564 BE.
//

import UIKit
import GRDB

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var quickCollectionView: UICollectionView!
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var defaults = UserDefaults.standard
    var user: [String] = []
    
    var dbPath: String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    var classId: [String] = []
    var imgNames: [String] = []
    var titles: [String] = []
    var allDate: [String] = []
    var workoutsYT: [String] = []
    var time: [String] = []
    var date: [String] = []
    var fullDate: [String] = []
    var month: [String] = []
    var monthText: [String] = []
    
    var classTypeName: [String] = []
    var classTypeImg: [String] = []
    
    var quickTitles: [String] = []
    var quickImgNames: [String] = []
    var quickYT: [String] = []
    var quickTrainer: [String] = []
    
    var classData: [String:[String]] = [:]
    var quickData: [String:[String]] = [:]
    
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
                let rows = try Row.fetchCursor(db, sql: "select c.class_id , c.picture_name name , c.video_name , strftime('%d',c.date1) date , c.date1 fulldate , strftime('%m',c.date1) month , c.time1 , ct.type_name from class c , class_type ct where c.ct_id = ct.ct_id")
                let rows2 = try Row.fetchCursor(db, sql: "select q.trainer , q.picture_name , q.video_name , ct.type_name from quick_video q , class_type ct where q.ct_id = ct.ct_id")
                let rows3 = try Row.fetchCursor(db, sql: "select ct.type_name , ct.picture_name from class_type ct")
                while let row = try rows.next() {
                    classId.append(row["class_id"])
                    titles.append(row["type_name"])
                    imgNames.append(row["name"])
                    workoutsYT.append(row["video_name"])
                    date.append(row["date"])
                    fullDate.append(row["fulldate"])
                    month.append(row["month"])
                    time.append(row["time1"])
                }
                while let row2 = try rows2.next() {
                    quickTitles.append(row2["type_name"])
                    quickImgNames.append(row2["picture_name"])
                    quickYT.append(row2["video_name"])
                    quickTrainer.append(row2["trainer"])
                }
                while let row3 = try rows3.next() {
                    classTypeName.append(row3["type_name"])
                    classTypeImg.append(row3["picture_name"])
                }
            }
            classTypeName.removeLast()
            classTypeImg.removeLast()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func monthNoToText() {
        let monthName = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        for m in month {
            monthText.append(monthName[Int(m)!-1])
        }
    }
    
    func loadDict() {
        classData.updateValue(classId, forKey: "id")
        classData.updateValue(titles, forKey: "title")
        classData.updateValue(imgNames, forKey: "image")
        classData.updateValue(workoutsYT, forKey: "youtube")
        classData.updateValue(date, forKey: "date")
        classData.updateValue(fullDate, forKey: "fulldate")
        classData.updateValue(monthText, forKey: "month")
        classData.updateValue(time, forKey: "time")
        
        quickData.updateValue(quickTitles, forKey: "title")
        quickData.updateValue(quickImgNames, forKey: "image")
        quickData.updateValue(quickTrainer, forKey: "trainer")
        quickData.updateValue(quickYT, forKey: "youtube")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        classData = ["id": [], "title": [], "image": [], "youtube": [], "date": [], "fulldate": [], "time": [], "month": []]
        quickData = ["title": [], "image": [], "trainer": [], "youtube": []]
        
        if searchText == "" {
            loadDict()
        }
        
        for i in 0..<titles.count {
            if titles[i].lowercased().contains(searchText.lowercased()) {
                classData["id"]!.append(classId[i])
                classData["title"]!.append(titles[i])
                classData["image"]!.append(imgNames[i])
                classData["youtube"]!.append(workoutsYT[i])
                classData["date"]!.append(date[i])
                classData["fulldate"]!.append(fullDate[i])
                classData["time"]!.append(time[i])
                classData["month"]!.append(monthText[i])
            }
        }
        
        for i in 0..<quickTitles.count {
            if quickTitles[i].lowercased().contains(searchText.lowercased()) || quickTrainer[i].lowercased().contains(searchText.lowercased()) {
                quickData["title"]!.append(quickTitles[i])
                quickData["image"]!.append(quickImgNames[i])
                quickData["trainer"]!.append(quickTrainer[i])
                quickData["youtube"]!.append(quickYT[i])
            }
        }
        
        classCollectionView.reloadData()
        quickCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView {
            return classTypeImg.count
        } else if collectionView == classCollectionView {
            return classData["title"]!.count
        } else {
            return quickData["title"]!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.classCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celldata", for: indexPath) as! MyCollectionViewCell
            cell.imageView.image = UIImage.init(named: classData["image"]![indexPath.row])
            cell.txtTitle.text = classData["title"]![indexPath.row]
            cell.txtTime.text = classData["time"]![indexPath.row]
            cell.txtDate.text = classData["date"]![indexPath.row]
            cell.txtMonth.text = classData["month"]![indexPath.row]
            cell.yt = classData["youtube"]![indexPath.row]
            cell.dateViewBlock.layer.cornerRadius = 10
            cell.imageView.layer.cornerRadius = 10
            cell.textViewBlock.layer.cornerRadius = 10
            return cell
        } else if collectionView  == self.quickCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celldata", for: indexPath) as! MyCollectionViewCell
            cell.dateViewBlock.isHidden = true
            cell.txtMonth.isHidden = true
            cell.txtDate.isHidden = true
            cell.imageView.image = UIImage.init(named: quickData["image"]![indexPath.row])
            cell.txtTitle.text = quickData["title"]![indexPath.row]
            cell.txtTime.text = quickData["trainer"]![indexPath.row]
            cell.yt = quickData["youtube"]![indexPath.row]
            cell.dateViewBlock.layer.cornerRadius = 10
            cell.imageView.layer.cornerRadius = 10
            cell.textViewBlock.layer.cornerRadius = 10
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typedata", for: indexPath) as! ClassTypeCollectionViewCell
            cell.typeImgView.image = UIImage.init(named: classTypeImg[indexPath.row])
            cell.typeImgView.layer.cornerRadius = 25
            cell.layer.cornerRadius = 25
            return cell
        }
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
    
    var selectedCell: [Bool] = [false,false,false,false,false,false,false,false]
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView {
            let cell = typeCollectionView.cellForItem(at: indexPath)
            if !selectedCell[indexPath.row] && !selectedCell.contains(true) {
                selectedCell[indexPath.row].toggle()
                cell!.layer.backgroundColor = UIColor.orange.cgColor
                typeFilter(index: indexPath.row)
            } else if selectedCell[indexPath.row] {
                selectedCell[indexPath.row].toggle()
                cell!.layer.backgroundColor = UIColor.white.cgColor
                loadDict()
                classCollectionView.reloadData()
                quickCollectionView.reloadData()
            }
        } else if collectionView == classCollectionView {
            let id = classData["id"]![indexPath.row]
            let memid = user[0]
            let histId = getHistoryId()
            let classDate = classData["fulldate"]![indexPath.row]
            
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
                print("added to History from my class")
            } catch {
                print(error.localizedDescription)
            }

        }
    }
    
    func typeFilter(index: Int) {
        
        let type: [String] = classTypeName
        classData = ["id": [], "title": [], "image": [], "youtube": [], "date": [],"fulldate": [], "time": [], "month": []]
        quickData = ["title": [], "image": [], "trainer": [], "youtube": []]
        
        for i in 0..<titles.count {
            if type[index] == "Weight Training " {
                if titles[i] == type[index] {
                    classData["id"]!.append(classId[i])
                    classData["title"]!.append(titles[i])
                    classData["image"]!.append(imgNames[i])
                    classData["youtube"]!.append(workoutsYT[i])
                    classData["date"]!.append(date[i])
                    classData["fulldate"]!.append(fullDate[i])
                    classData["time"]!.append(time[i])
                    classData["month"]!.append(monthText[i])
                }
            } else {
                if titles[i].lowercased().contains(type[index].lowercased()) {
                    classData["id"]!.append(classId[i])
                    classData["title"]!.append(titles[i])
                    classData["image"]!.append(imgNames[i])
                    classData["youtube"]!.append(workoutsYT[i])
                    classData["date"]!.append(date[i])
                    classData["fulldate"]!.append(fullDate[i])
                    classData["time"]!.append(time[i])
                    classData["month"]!.append(monthText[i])
                }
            }
        }
        
        for i in 0..<quickTitles.count {
            if type[index] == "Weight Training " {
                if quickTitles[i] == type[index] {
                    quickData["title"]!.append(quickTitles[i])
                    quickData["image"]!.append(quickImgNames[i])
                    quickData["trainer"]!.append(quickTrainer[i])
                    quickData["youtube"]!.append(quickYT[i])
                }
            } else {
                if quickTitles[i].lowercased().contains(type[index].lowercased()) {
                    quickData["title"]!.append(quickTitles[i])
                    quickData["image"]!.append(quickImgNames[i])
                    quickData["trainer"]!.append(quickTrainer[i])
                    quickData["youtube"]!.append(quickYT[i])
                }
            }
        }
        
        classCollectionView.reloadData()
        quickCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yt1" || segue.identifier == "yt2" {
            let vc = segue.destination as! YTViewController
            let cell = sender as! MyCollectionViewCell
            vc.ytLink = cell.yt
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Classes"
        connect2DB()
        readDBitem()
        monthNoToText()
        loadDict()
        user = defaults.object(forKey: "savedUser") as! [String]
    }
}

