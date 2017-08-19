//
//  AlarmAddViewController.swift
//  Alarm-ios-swift
//
//  Created by longyutao on 15-3-2.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

let Depart_code = NSNotification.Name("TaskDone")
let Arrive_code = NSNotification.Name("TaskDone2")
let Depart_sec = NSNotification.Name("TaskDone3")
let Arrive_sec = NSNotification.Name("TaskDone4")

class AlarmAddEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    UIPickerViewDelegate,
    UIPickerViewDataSource{

    
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var linePicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var departLbl: UILabel!
    @IBOutlet weak var arriveLbl: UILabel!
    
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmModel: Alarms = Alarms()
    var segueInfo: SegueInfo!
    var snoozeEnabled: Bool = false
    var enabled: Bool!
    
    let lineNumber:[String] = ["1","2","3","4","5","6","7","8","9"]
    let lineText: [[String]] = [
        ["신설동", "동묘앞", "동대문", "종로5가", "종각", "시청", "서울역"],
        ["시청", "을지로입구", "을지로3가", "을지로4가", "동대문역사문화공원", "신당", "상왕십리", "왕십리"],
        ["대화", "주엽", "정발산", "마두", "백석", "대곡", "화정", "원당", "삼송", "지축"],
        ["당고개", "상계", "노원", "창동", "쌍문", "수유"],
        ["방화", "개화산", "김포공항", "송정", "마곡", "발산"],
        ["응암", "역촌", "불광", "독바위", "연신내", "고려대", "안암", "새절"],
        ["장암", "도봉산", "수락산", "마들", "노원", "중계", "하계"],
        ["암사", "천호", "강동구청", "몽촌토성", "잠실", "석촌", "송파", "가락시장"],
        ["개화", "김포공항", "공항시장", "신방화", "양천향", "가양", "중미"]
    ]
    
    
    
    
    
    
    //선택지보기의 열 설정 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //열에서 항목의 총 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return lineNumber.count
        }else if component == 1{
            let indexcount = pickerView.selectedRow(inComponent: 0)
            return lineText[indexcount].count
        }
        else{
            let indexcount = pickerView.selectedRow(inComponent: 0)
            return lineText[indexcount].count
        }
    }

    //뭘 보여줄꺼?
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let indexselect = pickerView.selectedRow(inComponent: 0)
        if component == 0 {
            return lineNumber[row] }
        else if component == 1 {
            //let indexselect = pickerView.selectedRow(inComponent: 0)
            return lineText[indexselect][row]
            
            
        }
        else{
            // let indexselect = pickerView.selectedRow(inComponent: 0)
            
            return lineText[indexselect][row]
            
        }
        
    }

    //초기화
    
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        if component == 0 {
            
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            
            let one = UIImage(named: "1.png" )
            let two = UIImage(named: "2.png" )
            let three = UIImage(named: "3.png" )
            let four = UIImage(named: "4.png" )
            let five = UIImage(named: "5.png" )
            let six = UIImage(named: "6.png" )
            let seven = UIImage(named: "7.png" )
            let eight = UIImage(named: "8.png" )
            let nine = UIImage(named: "9.png" )
            
            
            var item1 = lineNumber[row]
            switch(item1){
                
            case Optional("Label")!:
                image2.image = one
                
            case "1":
                image2.image = one
                
            case "2":
                image2.image = two
                
            case "3":
                image2.image = three
                
            case "4":
                image2.image = four
                
            case "5":
                image2.image = five
                
            case "6":
                image2.image = six
                
            case "7":
                image2.image = seven
                
            case "8":
                image2.image = eight
                
            case "9":
                image2.image = nine
                
            default:
                return
            }
            
            linePicker.selectRow(0, inComponent: 1, animated: true)
            linePicker.selectRow(0, inComponent: 2, animated: true)
            self.linePicker.reloadAllComponents()
            
            if item1 == "1"{
                departLbl.text = "신설동"
                arriveLbl.text = "신설동"
            }
            if item1 == "2"{
                departLbl.text = "시청"
                arriveLbl.text = "시청"
            }
            if item1 == "3"{
                departLbl.text = "대화"
                arriveLbl.text = "대화"
            }
            if item1 == "4"{
                departLbl.text = "당고개"
                arriveLbl.text = "당고개"
            }
            if item1 == "5"{
                departLbl.text = "방화"
                arriveLbl.text = "방화"
            }
            if item1 == "6"{
                departLbl.text = "응암"
                arriveLbl.text = "응암"
            }
            if item1 == "7"{
                departLbl.text = "장암"
                arriveLbl.text = "장암"
            }
            if item1 == "8"{
                departLbl.text = "암사"
                arriveLbl.text = "암사"
            }
            if item1 == "9"{
                departLbl.text = "개화"
                arriveLbl.text = "개화"
            }

            
            return lineLbl.text = lineNumber[row]
            
        } else if component == 1 {
            
            if lineLbl.text == Optional("Label") {  //Line이 선택X 경우
                
                
                return departLbl.text = lineText[0][row]
            } else {
                
                
                return departLbl.text = lineText[Int(lineLbl.text!)!-1][row]
            }
        } else {
            if lineLbl.text == Optional("Label") {
                
                return arriveLbl.text = lineText[0][row]
            } else {
                return arriveLbl.text = lineText[Int(lineLbl.text!)!-1][row]
            }
        }
        
        //return lineSelected.text = lineNumber[row]
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linePicker.delegate = self
        linePicker.dataSource = self
        
        let one = UIImage(named: "1.png" )
        image2.image = one
        
        lineLbl.text = "1"
        departLbl.text = "신설동"
        arriveLbl.text = "신설동"
    
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        alarmModel=Alarms()
        tableView.reloadData()
        snoozeEnabled = segueInfo.snoozeEnabled
        
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        NotificationCenter.default.addObserver(forName: Depart_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 출발역 코드: \(userInfo["data"] as! String)")
            }
        }
        NotificationCenter.default.addObserver(forName: Arrive_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 도착역 코드: \(userInfo["data"] as! String)")
            }
        }
        NotificationCenter.default.addObserver(forName: Depart_sec, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 출발역 떠나는 시간: \(userInfo["data"] as! String)")
                
                print("TRAIN_NO : ",userInfo["data2"] as! String) //train_num을 받아온다
                
                TRAIN_NO = userInfo["data2"] as! String
                self.getCodeByName_arrive(line: self.lineLbl.text!)
                time1 = userInfo["data"] as! String
            }
        }
        NotificationCenter.default.addObserver(forName: Arrive_sec, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 도착역 도착 시간: \(userInfo["data"] as! String)")
                time2 = userInfo["data"] as! String
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveEditAlarm(_ sender: AnyObject) {
        //let date = Scheduler.correctSecondComponent(date: pickerView.date)
        //에딧창에서의 레이블 받아오는 기능
        let strDepart = departLbl.text
        let strArrive = arriveLbl.text
        let strLine = lineLbl.text

        
        
        let index = segueInfo.curCellIndex
        var tempAlarm = Alarm()
        //tempAlarm.date = date
        tempAlarm.depart = strDepart!
        tempAlarm.arrive = strArrive!
        tempAlarm.line = strLine!
        tempAlarm.label = segueInfo.label
        tempAlarm.enabled = true
        tempAlarm.mediaLabel = segueInfo.mediaLabel
        tempAlarm.mediaID = segueInfo.mediaID
        tempAlarm.snoozeEnabled = snoozeEnabled
        tempAlarm.repeatWeekdays = segueInfo.repeatWeekdays
        tempAlarm.uuid = UUID().uuidString
        tempAlarm.onSnooze = false
        if segueInfo.isEditMode {
            alarmModel.alarms[index] = tempAlarm
        }
        else {
            alarmModel.alarms.append(tempAlarm)
        }
        self.performSegue(withIdentifier: Id.saveSegueIdentifier, sender: self)
        //----------------------출발/도착역 label로 api함수들 실행--------------
        getCodeByName_depart(line: lineLbl.text!)
        
        NotificationCenter.default.addObserver(forName: Depart_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                departNum = userInfo["data"] as! String
                
                self.departSec(departNum: departNum) // 만약 noti가 departNum을 받으면 departSec함수에 집어넣어서 실행 시킨다
                
            }
        }
        
        NotificationCenter.default.addObserver(forName: Arrive_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                arriveNum = userInfo["data"] as! String
                
                self.arriveSec(arriveNum: arriveNum, trainNum: TRAIN_NO) // 만약 noti가 departNum을 받으면 arriveSec함수에 집어넣어서 실행 시킨다
                
            }
        }

        
        
        
        
    }
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        if segueInfo.isEditMode {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
            //원래 4개
        }
        else {
            return 1
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: Id.settingIdentifier, for: indexPath)

        if indexPath.section == 0 {
            
//            if indexPath.row == 0 {
//                
//                cell.textLabel!.text = "Repeat"
//                cell.detailTextLabel!.text = WeekdaysViewController.repeatText(weekdays: segueInfo.repeatWeekdays)
//                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//            }
//            else if indexPath.row == 1 {
//                cell.textLabel!.text = "Label"
//                cell.detailTextLabel!.text = segueInfo.label
//                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//            }
            if indexPath.row == 0 {
                cell.textLabel!.text = "Sound"
                cell.detailTextLabel!.text = segueInfo.mediaLabel
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
//            else if indexPath.row == 3 {
//               
//                cell.textLabel!.text = "Snooze"
//                let sw = UISwitch(frame: CGRect())
//                sw.addTarget(self, action: #selector(AlarmAddEditViewController.snoozeSwitchTapped(_:)), for: UIControlEvents.touchUpInside)
//                
//                if snoozeEnabled {
//                   sw.setOn(true, animated: false)
//                }
//                
//                cell.accessoryView = sw
//            }
        }
        else if indexPath.section == 1 {
            cell = UITableViewCell(
                style: UITableViewCellStyle.default, reuseIdentifier: Id.settingIdentifier)
            cell.textLabel!.text = "Delete Alarm"
            cell.textLabel!.textAlignment = .center
            cell.textLabel!.textColor = UIColor.red
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            switch indexPath.row{
//            case 0:
//                performSegue(withIdentifier: Id.weekdaysSegueIdentifier, sender: self)
//                cell?.setSelected(true, animated: false)
//                cell?.setSelected(false, animated: false)
//            case 1:
//                performSegue(withIdentifier: Id.labelSegueIdentifier, sender: self)
//                cell?.setSelected(true, animated: false)
//                cell?.setSelected(false, animated: false)
            case 0:
                performSegue(withIdentifier: Id.soundSegueIdentifier, sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
            default:
                break
            }
        }
        else if indexPath.section == 1 {
            //delete alarm
            alarmModel.alarms.remove(at: segueInfo.curCellIndex)
            performSegue(withIdentifier: Id.saveSegueIdentifier, sender: self)
        }
            
    }
   
    @IBAction func snoozeSwitchTapped (_ sender: UISwitch) {
        snoozeEnabled = sender.isOn
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Id.saveSegueIdentifier {
            let dist = segue.destination as! MainAlarmViewController
            let cells = dist.tableView.visibleCells
            for cell in cells {
                let sw = cell.accessoryView as! UISwitch
                if sw.tag > segueInfo.curCellIndex
                {
                    sw.tag -= 1
                }
            }
            alarmScheduler.reSchedule()
        }
        else if segue.identifier == Id.soundSegueIdentifier {
            //TODO
            let dist = segue.destination as! MediaViewController
            dist.mediaID = segueInfo.mediaID
            dist.mediaLabel = segueInfo.mediaLabel
        }
//        else if segue.identifier == Id.labelSegueIdentifier {
//            let dist = segue.destination as! LabelEditViewController
//            dist.label = segueInfo.label
//        }
//        else if segue.identifier == Id.weekdaysSegueIdentifier {
//            let dist = segue.destination as! WeekdaysViewController
//            dist.weekdays = segueInfo.repeatWeekdays
//        }
    }
    
//    @IBAction func unwindFromLabelEditView(_ segue: UIStoryboardSegue) {
//        let src = segue.source as! LabelEditViewController
//        segueInfo.label = src.label
//    }
//    
//    @IBAction func unwindFromWeekdaysView(_ segue: UIStoryboardSegue) {
//        let src = segue.source as! WeekdaysViewController
//        segueInfo.repeatWeekdays = src.weekdays
//    }
    
    @IBAction func unwindFromMediaView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! MediaViewController
        segueInfo.mediaLabel = src.mediaLabel
        segueInfo.mediaID = src.mediaID
    }
    
    //-------------------------------API를 받아오는 함수들------------------------------------
    
    
    func getCodeByName_depart(line: String) {
        
        var findNum :String? = "" //찾아야하는 FR_CODE
        
        let urlPath = "http://openapi.seoul.go.kr:8088/6b6d46455562617a37306d56437552/json/SearchSTNBySubwayLineService/1/101/\(line)/" //데이터가 101인 이유는 1호선이 101개라..
        let url = NSURL(string: urlPath)
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url! as URL,  completionHandler:  {(data, response, error) -> Void in
            
            print("api받기 시작")
            
            do {
                let jsonResult =
                    try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                
                let result = jsonResult as? [String: Any]
                let result_row = result?["SearchSTNBySubwayLineService"] as? [String: Any]
                let result_row_station = result_row?["row"] as? [Any]
                
                var station_name : Array<String> = Array<String>() //역 이름이 들어갈 배열
                var station_num : Array<String> = Array<String>() //역 코드가 들어갈 배열
                
                
                
                for num in 0...(result_row_station?.count)! - 1 {
                    
                    var result_row_station_array = result_row_station?[num] as? [String: String]
                    // line에 대한 num번째 역 ex) num = 1이면 안암, num = 2 이면 고려대
                    
                    let result_row_station_name = result_row_station_array?["STATION_NM"]
                    station_name.append(result_row_station_name!)
                    // line의 모든 station 이름을 배열에 삽입
                    
                    let result_row_station_num = result_row_station_array?["FR_CODE"]
                    station_num.append(result_row_station_num!)
                    // line의 모든 station 코드를 배열에 삽입
                    
                }
                
                print("text잘 받니??",self.departLbl.text!)
                for a in 0...station_num.count - 1 {
                    
                    if station_name[a] == self.departLbl.text {  //label의 값을 가져오기 때문에 불안정하다.. 나중에 바꿔주자!!
                        findNum = station_num[a]
                        
                    }
                    
                    
                }
                NotificationCenter.default.post(name: Depart_code, object: nil, userInfo:["data":findNum!])
                
                
            } catch {
                print("Error~~")
            }
            
            
            
            
            
        })//task 닫음, 여기까지 task 선언임...
        
        
        task.resume() //task 실행
        
        
        
    }  //getCodeByName_depart 함수 끝
    
    
    
    func getCodeByName_arrive(line: String) {
        
        
        var findNum :String? = "" //찾아야하는 FR_CODE
        
        let urlPath = "http://openapi.seoul.go.kr:8088/6b6d46455562617a37306d56437552/json/SearchSTNBySubwayLineService/1/101/\(line)/" //데이터가 101인 이유는 1호선이 101개라..
        let url = NSURL(string: urlPath)
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url! as URL,  completionHandler:  {(data, response, error) -> Void in
            
            print("api받기 시작")
            
            do {
                let jsonResult =
                    try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                
                let result = jsonResult as? [String: Any]
                let result_row = result?["SearchSTNBySubwayLineService"] as? [String: Any]
                let result_row_station = result_row?["row"] as? [Any] //as? [String: Any]
                
                
                
                var station_name : Array<String> = Array<String>() //역 이름이 들어갈 배열
                var station_num : Array<String> = Array<String>() //역 코드가 들어갈 배열
                
                
                
                for num in 0...(result_row_station?.count)! - 1 {
                    
                    var result_row_station_array = result_row_station?[num] as? [String: String]
                    // line에 대한 num번째 역 ex) num = 1이면 안암, num = 2 이면 고려대
                    
                    let result_row_station_name = result_row_station_array?["STATION_NM"]
                    station_name.append(result_row_station_name!)
                    // line의 모든 station 이름을 배열에 삽입
                    
                    let result_row_station_num = result_row_station_array?["FR_CODE"]
                    station_num.append(result_row_station_num!)
                    // line의 모든 station 코드를 배열에 삽입
                    
                }
                
                print("text잘 받니??",self.arriveLbl.text!)
                for a in 0...station_num.count - 1 {
                    
                    if station_name[a] == self.arriveLbl.text! {
                        findNum = station_num[a]
                        
                    }
                    
                    
                }
                NotificationCenter.default.post(name: Arrive_code, object: nil, userInfo:["data":findNum!])
                
                
            } catch {
                print("Error~~")
            }
            
            
            
            
            
        })//task 닫음, 여기까지 task 선언임...
        
        
        task.resume() //task 실행
        
        
        
    }  //getCodeByName_arrive 함수 끝
    
    func departSec(departNum: String) {
        
        let urlPath = "http://openapi.seoul.go.kr:8088/4f6142724a62617a38346769687741/json/SearchSTNTimeTableByFRCodeService/1/200/\(departNum)/1/1/"
        let url = NSURL(string: urlPath)
        
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: url! as URL, completionHandler: {(data, response, error) -> Void in
            
            do {
                let jsonResult =
                    try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                let result = jsonResult as? [String: Any]
                let result_row = result?["SearchSTNTimeTableByFRCodeService"] as? [String: Any]
                let result_row_station = result_row?["row"] as? [Any] //as? [String: Any]
                
                //let result_row_station_0 = result_row_station?[0] as? [String: String]
                //0 이면 6호선 제일 첫 열차 정보 return -> 응암
                
                
                var station_name : Array<String> = Array<String>()
                var station_num : Array<String> = Array<String>()
                var arrive_time : Array<String> = Array<String>()
                var left_time : Array<String> = Array<String>()
                var train_num : Array<String> = Array<String>()
                
                //var startIndex : String.Index = arriveNum.startIndex
                
                // 첫번째 글자에 대한 Index
                //let char_first = arriveNum[startIndex]
                //let trainNum = String(char_first) + "020"  //다른 호선에서 없는 경우도 있다.. 나중에 수정하자
                
                
                let num = 10  //열번째 배열을 기준으로 잡자
                //for num in 0...result_row_station!.count - 1 {  //15개 정도만 가져오면 찾을 수 있겠지???
                
                //var test_row_station_array = result_row_station?[num] as? [String: String]
                
                //if test_row_station_array?["TRAIN_NO"] == trainNum {
                
                var result_row_station_array = result_row_station?[num] as? [String: String]
                
                let result_row_station_name = result_row_station_array?["STATION_NM"]
                station_name.append(result_row_station_name!)
                
                let result_row_station_num = result_row_station_array?["FR_CODE"]
                station_num.append(result_row_station_num!)
                
                let result_row_station_arrive = result_row_station_array?["ARRIVETIME"]
                arrive_time.append(result_row_station_arrive!)
                
                let result_row_station_left = result_row_station_array?["LEFTTIME"]
                left_time.append(result_row_station_left!)
                
                let result_row_train_num = result_row_station_array?["TRAIN_NO"]
                train_num.append(result_row_train_num!)
                //}
                
                //}
                
                
                let myDict = [ "data": left_time[0], "data2":train_num[0]] //dictionary 형태로 여러개의 데이터를 보낼수도 있다!!
                
                NotificationCenter.default.post(name: Depart_sec, object: nil, userInfo:myDict) //data2에 TRAIN_NO 정보가 들어간다.
                
                
            } catch {
                print("Error~~")
                
            }
        })
        
        task.resume()
        
        
        
        
    }
    
    func arriveSec(arriveNum: String, trainNum: String) {  //train number 가져와서 계산
        
        let urlPath = "http://openapi.seoul.go.kr:8088/4f6142724a62617a38346769687741/json/SearchSTNTimeTableByFRCodeService/1/200/\(arriveNum)/1/1/"
        let url = NSURL(string: urlPath)
        
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: url! as URL, completionHandler: {(data, response, error) -> Void in
            
            do {
                let jsonResult =
                    try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                let result = jsonResult as? [String: Any]
                let result_row = result?["SearchSTNTimeTableByFRCodeService"] as? [String: Any]
                let result_row_station = result_row?["row"] as? [Any] //as? [String: Any]
                
                
                var station_name : Array<String> = Array<String>()
                var station_num : Array<String> = Array<String>()
                var arrive_time : Array<String> = Array<String>()
                var left_time : Array<String> = Array<String>()
                
                
                //var startIndex : String.Index = arriveNum.startIndex
                
                // 첫번째 글자에 대한 Index
                //let char_first = arriveNum[startIndex]
                //let trainNum = String(char_first) + "020"
                
                
                
                for num in 0...result_row_station!.count - 1 {  //15개 정도만 가져오면 찾을 수 있겠지???
                    
                    var test_row_station_array = result_row_station?[num] as? [String: String]
                    
                    if test_row_station_array?["TRAIN_NO"] == trainNum {
                        
                        var result_row_station_array = result_row_station?[num] as? [String: String]
                        
                        let result_row_station_name = result_row_station_array?["STATION_NM"]
                        station_name.append(result_row_station_name!)
                        
                        let result_row_station_num = result_row_station_array?["FR_CODE"]
                        station_num.append(result_row_station_num!)
                        
                        let result_row_station_arrive = result_row_station_array?["ARRIVETIME"]
                        arrive_time.append(result_row_station_arrive!)
                        
                        let result_row_station_left = result_row_station_array?["LEFTTIME"]
                        left_time.append(result_row_station_left!)
                        
                    }
                    
                }
                
                //let num = 10
                
                NotificationCenter.default.post(name: Arrive_sec, object: nil, userInfo:["data":left_time[0]])
                //원래는 arrive_time[0]으로 해야 정확하지만.... 상행 하행 고려를 해줘야 한다!!
                
                
                
            } catch {
                print("Error~~")
                
            }
        })
        
        task.resume()
        
    }
}
