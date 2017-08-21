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

let Depart_code = NSNotification.Name("Task")
let Arrive_code = NSNotification.Name("Task2")
let Depart_sec = NSNotification.Name("Task3")
let Arrive_sec = NSNotification.Name("Task4")

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
        ["가능", "가산디지털단지", "간석", "개봉", "관악", "광명", "광운대", "구로", "구일", "군포", "금정", "금천구청",  "남영", "노량진", "녹양", "녹천", "당정", "대방", "덕계", "덕정", "도봉", "도봉산", "도원", "도화", "독산", "동대문", "동두천", "동두천중앙", "동묘앞", "동암", "동인천", "두정", "망월사", "명학", "방학", "배방", "백운", "병점", "보산", "봉명", "부개", "부평", "부천", "서동탄", "서울역", "서정리", "석계", "석수", "성균관대", "성환", "세류",  "세마", "소사", "소요산", "송내", "송탄", "수원", "시청", "신길", "신도림", "신설동", "신이문", "신창", "쌍용", "아산", "안양", "양주", "역곡", "영등포", "오류동", "오산", "오산대", "온수", "온양온천", "외대앞", "용산", "월계", "의왕", "의정부", "인천", "제기동", "제물포", "종각", "종로3가", "종로5가", "주안", "중동", "지제", "지행", "직산", "진위", "창동", "천안", "청량리", "평택", "화서", "회기", "회룡"],
        ["강남", "강변", "건대입구", "교대", "구로디지털단지", "구의", "까치산", "낙성대", "당산", "대림", "도림천", "동대문역사문화공원", "뚝섬", "문래", "방배", "봉천", "사당", "삼성", "상왕십리", "서울대입구", "서초", "선릉", "성수", "시청", "신답", "신당", "신도림", "신림", "신대방", "신설동", "신정네거리", "신천", "신촌", "아현", "양천구청", "역삼", "영등포구청", "왕십리", "용답", "용두", "을지로3가", "을지로4가", "을지로입구", "이대", "잠실", "잠실나루", "종합운동장", "충정로", "한양대", "합정", "홍대입구"],
        ["가락시장", "경복궁", "경찰병원", "고속터미널", "교대", "구파발", "금호", "남부터미널", "녹번", "대곡", "대청", "대치", "대화", "도곡", "독립문", "동대입구", "마두", "매봉", "무악재", "백석", "불광", "삼송", "수서", "신사", "안국", "압구정", "약수", "양재", "연신내", "오금", "옥수", "원당", "을지로3가", "일원", "잠원", "정발산", "종로3가", "주엽", "지축", "충무로", "학여울", "홍제", "화정"],
        ["경마공원", "고잔", "공단", "과천", "금정", "길음", "남태령", "노원", "당고개", "대공원", "대야미", "동대문", "동대문역사문화공원", "동작", "명동", "미아", "미아삼거리", "반월", "범계", "사당", "산본", "삼각지", "상계", "상록수", "서울역", "선바위", "성신여대입구", "수리산", "수유", "숙대입구", "신길온천", "신용산", "쌍문", "안산", "오이도", "이수", "이촌", "인덕원", "정부과천청사", "정왕", "중앙", "창동", "충무로", "평촌", "한대앞", "한성대입구", "혜화", "회현" ],
        ["강동", "개롱", "개화산", "거여", "고덕", "공덕", "광나루", "광화문", "군자", "굽은다리", "길동", "김포공항", "까치산", "답십리", "동대문역사문화공원", "둔촌동", "마곡", "마장", "마천", "마포", "명일", "목동", "발산", "방이", "방화", "상일동", "서대문", "송정", "신금호", "신길", "신정", "아차산", "애오개", "양평", "여의나루", "여의도", "영등포구청", "영등포시장", "오금", "오목교", "올림픽공원", "왕십리", "우장산", "을지로4가", "장한평", "종로3가", "천호", "청구", "충정로", "행당", "화곡" ],
        ["고려대", "공덕", "광흥창", "구산", "녹사평", "대흥", "독바위", "돌곶이", "동묘앞", "디지털미디어시티", "마포구청", "망원", "버티고개", "보문", "봉화산", "불광", "삼각지", "상수", "상월곡", "새절", "석계", "신당", "안암", "약수", "역촌", "연신내", "월곡", "월드컵경기장", "응암", "이태원", "증산", "창신", "청구", "태릉입구", "한강진", "합정", "화랑대", "효창공원앞" ],
        ["가산디지털단지", "강남구청", "건대입구", "고속터미널", "공릉", "광명사거리", "군자", "굴포천", "까치울", "남구로", "남성", "내방", "노원", "논현", "대림", "도봉산", "뚝섬유원지", "마들", "먹골", "면목", "반포", "보라매", "부천시청", "부천종합운동장", "부평구청", "사가정", "삼산체육관", "상도", "상동", "상봉", "수락산", "숭실대입구", "신대방삼거리", "신중동", "신풍", "어린이대공원", "온수", "용마산", "이수", "장승배기", "장암", "중계", "중곡", "중화", "천왕", "철산", "청담", "춘의", "태릉입구", "하계", "학동" ],
        ["가락시장", "강동구청", "남한산성입구", "단대오거리", "모란", "몽촌토성", "문정", "복정", "산성", "석촌", "송파", "수진", "신흥", "암사", "잠실", "장지", "천호" ],
        ["가양", "개화", "고속터미널", "공항시장", "구반포", "국회의사당", "김포공항", "노들", "노량진", "당산", "동작", "등촌", "봉은사", "사평", "삼성중앙", "샛강", "선유도", "선정릉", "신논현", "신목동", "신반포", "신방화", "양천향교", "언주", "여의도", "염창", "종합운동장", "증미", "흑석" ]
    ]
    
    var TRAIN_NO = " "
    
    //let date = "17:18:59"
    var time1: String = " "
    var time2: String = " "
    
    var departNum: String = "디폴트"
    var arriveNum: String = "디폴트2"  // 시간을 계산하기 위해 받아와야하는 역 이름 변수들 + 디폴트 값을 안 만들었더니 에러가 생겨서...
    
    
    
    
    
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
                departLbl.text = "가능"
                arriveLbl.text = "가능"
            }
            if item1 == "2"{
                departLbl.text = "강남"
                arriveLbl.text = "강남"
            }
            if item1 == "3"{
                departLbl.text = "가락시장"
                arriveLbl.text = "가락시장"
            }
            if item1 == "4"{
                departLbl.text = "경마공원"
                arriveLbl.text = "경마공원"
            }
            if item1 == "5"{
                departLbl.text = "강동"
                arriveLbl.text = "강동"
            }
            if item1 == "6"{
                departLbl.text = "고려대"
                arriveLbl.text = "고려대"
            }
            if item1 == "7"{
                departLbl.text = "가산디지털단지"
                arriveLbl.text = "가산디지털단지"
            }
            if item1 == "8"{
                departLbl.text = "가락시장"
                arriveLbl.text = "가락시장"
            }
            if item1 == "9"{
                departLbl.text = "가양"
                arriveLbl.text = "가양"
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
                
                self.TRAIN_NO = userInfo["data2"] as! String
                self.getCodeByName_arrive(line: self.lineLbl.text!)
                self.time1 = userInfo["data"] as! String
            }
        }
        NotificationCenter.default.addObserver(forName: Arrive_sec, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 도착역 도착 시간: \(userInfo["data"] as! String)")
                self.time2 = userInfo["data"] as! String
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
                self.departNum = userInfo["data"] as! String
                
                self.departSec(departNum: self.departNum) // 만약 noti가 departNum을 받으면 departSec함수에 집어넣어서 실행 시킨다
                
            }
        }
        
        NotificationCenter.default.addObserver(forName: Arrive_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                self.arriveNum = userInfo["data"] as! String
                
                self.arriveSec(arriveNum: self.arriveNum, trainNum: self.TRAIN_NO) // 만약 noti가 departNum을 받으면 arriveSec함수에 집어넣어서 실행 시킨다
                
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
