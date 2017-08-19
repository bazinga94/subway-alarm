//
//  frontViewController.swift
//  Alarm-ios-swift
//
//  Created by cscoi009 on 2017. 8. 14..
//  Copyright © 2017년 LongGames. All rights reserved.
//
import UIKit
import Foundation
import MediaPlayer
import UserNotifications // 로컬 푸시 권한 요청

let Start_code = NSNotification.Name("TaskDone")
let End_code = NSNotification.Name("TaskDone2")
let Start_sec = NSNotification.Name("TaskDone3")
let End_sec = NSNotification.Name("TaskDone4")

let dateFormatter = DateFormatter()
var TRAIN_NO = " "

//let date = "17:18:59"
var time1: String = " "
var time2: String = " "

var departNum: String = "디폴트"
var arriveNum: String = "디폴트2"  // 시간을 계산하기 위해 받아와야하는 역 이름 변수들 + 디폴트 값을 안 만들었더니 에러가 생겨서...

class frontViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, AVAudioPlayerDelegate{
    
    var audioPlayer: AVAudioPlayer? //알람때문에

    var mediaLabel: String!
    var mediaID: String!
    

    @IBOutlet weak var image1: UIImageView!  //호선 사진 보여주는 label

    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
   

    
    @IBOutlet weak var subwayPicker: UIPickerView!
    @IBOutlet weak var subwaytableView: UITableView!
    
    
    @IBOutlet weak var numLbl: UILabel!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var endLbl: UILabel!
    
    
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmModel: Alarms = Alarms()
    var segueInfo: SegueInfo!
    //var snoozeEnabled: Bool = false
    var enabled: Bool!
    
    var resumeTapped = false
    
    var seconds = 60 // this variable will hold a starting value of seconds. it could be any amount above 0
    
    var soundTimer: Timer = Timer() //소리 알람을 위해
    
    var timer: Timer = Timer() //숫자 타이머를 위해
    var isTimerRunning = false// this will be used to make sure only one timer is created at a time
    
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
   
    @IBAction func startButtonTapped(_ sender: AnyObject) {  //start버튼을 누를때 실행 함수
        if isTimerRunning == false {
            
            self.startButton.isEnabled = false
            resetButton.isEnabled = true
        }
        
        getCodeByName_depart(line: numLbl.text!)
        //getCodeByName_arrive(line: numLbl.text!) //역 코드를 찾는 함수 실행!!
        
        
        NotificationCenter.default.addObserver(forName: Start_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                departNum = userInfo["data"] as! String
                
                self.departSec(departNum: departNum) // 만약 noti가 departNum을 받으면 departSec함수에 집어넣어서 실행 시킨다
                
            }
        }
        
        NotificationCenter.default.addObserver(forName: End_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                arriveNum = userInfo["data"] as! String
                
                self.arriveSec(arriveNum: arriveNum, trainNum: TRAIN_NO) // 만약 noti가 departNum을 받으면 arriveSec함수에 집어넣어서 실행 시킨다
                
            }
        }
        //---------------------------------alert 생성 함수------------------------
        let alertController = UIAlertController(title: "출발: \(startLbl.text) 도착: \(endLbl.text)", message: "알람을 켜시겠습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
            
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Start", style: .destructive) { action in
            //Start 버튼을 눌렀을때 실행 하는 시간 계산 함수
            
            
            dateFormatter.dateFormat = "HH:mm:ss"
            let resultDate1 = dateFormatter.date(from: time1)
            let resultDate2 = dateFormatter.date(from: time2)
            
            
            let diffsec: Double = 5//resultDate2!.timeIntervalSince(resultDate1!) - 60 // 60초를 빼주는 이유는 여유있게 알람이 울리도록 하기위해
            print("시간 차이는?? : \(abs(diffsec)) 초")
            self.seconds = abs(Int(diffsec))
            self.runTimer()//에러가 발생한다????
            self.soundTimer = Timer.scheduledTimer(withTimeInterval: abs(diffsec),
                                                   repeats: false) {
                                                    timer in
                                                    let bell: String = "bell"
                                                    self.playSound(bell) //알람을 울리게 하는 함수 "bell.mp3"
                                                    //Put the code that be called by the timer here.
                                                    print("알람 발생!")
            }
            
            
            //--------------------------------푸시알림 함수----------------------------------------
            let content = UNMutableNotificationContent()
            content.title = "출발역 : \(self.startLbl.text!)" //"This is title"
            content.subtitle = "도착역 : \(self.endLbl.text!)" //"This is Subtitle"
            content.body = "\(abs(diffsec))초 걸림.... 빨리 내려!!!!!!!!!"
            content.badge = 1  //앱 아이콘에 알림 표시 추가 함
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: abs(diffsec), repeats: false)
            
            let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger) //notification ID 는 "timerdone"
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil )
        }
        alertController.addAction(destroyAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
        
        
        
        
        
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()  //숫자 타이머 정지
        soundTimer.invalidate()  //소리 나는 알람 취소/정지 해주는 함수
        seconds = 0     // 기본 타이머는 60초 -> 시간차이변수로 바꿔주자!
        
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        startButton.isEnabled = true
        //pauseButton.isEnabled = false
        
        resetButton.isEnabled = false
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timerdone"]) //push알림도 제거하는 함수!
        
        
        self.audioPlayer!.stop() //알람을 멈추는 함수 테스트용!! 나중에 지워야함 ~초뒤에 울릴 알람을 제거하는게 아니라 알람을 멈춤....
        
    }
//    @IBAction func snoozeSwitchTapped (_ sender: UISwitch) {
//        
//        snoozeEnabled = sender.isOn
//    }
    
    @IBAction func unwindFromFirstMediaView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! firstMediaTableViewController
                segueInfo.mediaLabel = src.mediaLabel
                segueInfo.mediaID = src.mediaID
    }
    
    func playSound(_ soundName: String) {
        
        //vibrate phone first
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
                                              nil,
                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        },
                                              nil)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
            return
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1  //audioPlayer!.stop() 명령 전까지 계속 울림...
        audioPlayer!.play()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(frontViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        //isTimerRunning = true
        //pauseButton.isEnabled = true
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate() // time's up
        
        }else {
        
            seconds -= 1 // this will decrement the seconds.
            timerLabel.text = timeString(time: TimeInterval(seconds)) //this will update the label
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i : %02i : %02i", hours, minutes, seconds)
    }
    
    
    
    
    //선택기보기의 열 설정 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    //열에서 항목의 총 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            
            return lineNumber.count
        }
            
        else if component == 1{
            let indexcount = pickerView.selectedRow(inComponent: 0)
            
            return lineText[indexcount].count
        }
            
        else{
            let indexcount = pickerView.selectedRow(inComponent: 0)
            
            return lineText[indexcount].count }
    }
    

    //뭘 보여줄꺼?
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let indexselect = pickerView.selectedRow(inComponent: 0)
        
        if component == 0 {
            
            return lineNumber[row] }
            
        else if component == 1 {
            
            return lineText[indexselect][row]
        }
            
        else{
            
            return lineText[indexselect][row]
        }
    
    }
    //초기화
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            
            var item1 = lineNumber[row]
            
            let one = UIImage(named: "1.png" )
            let two = UIImage(named: "2.png" )
            let three = UIImage(named: "3.png" )
            let four = UIImage(named: "4.png" )
            let five = UIImage(named: "5.png" )
            let six = UIImage(named: "6.png" )
            let seven = UIImage(named: "7.png" )
            let eight = UIImage(named: "8.png" )
            let nine = UIImage(named: "9.png" )
            
            
            
            switch(item1){
                
            case Optional("Label")!:
                image1.image = one
                
            case "1":
                image1.image = one
                
            case "2":
                image1.image = two
                
            case "3":
                image1.image = three
                
            case "4":
                image1.image = four
                
            case "5":
                image1.image = five
                
            case "6":
                image1.image = six
                
            case "7":
                image1.image = seven
                
            case "8":
                image1.image = eight
                
            case "9":
                image1.image = nine
                
            default:
                return
            }

            subwayPicker.selectRow(0, inComponent: 1, animated: true)
            subwayPicker.selectRow(0, inComponent: 2, animated: true)
            self.subwayPicker.reloadAllComponents()
            
            if item1 == "1"{
                startLbl.text = "신설동"
                endLbl.text = "신설동"
            }
            if item1 == "2"{
                startLbl.text = "시청"
                endLbl.text = "시청"
            }
            if item1 == "3"{
                startLbl.text = "대화"
                endLbl.text = "대화"
            }
            if item1 == "4"{
                startLbl.text = "당고개"
                endLbl.text = "당고개"
            }
            if item1 == "5"{
                startLbl.text = "방화"
                endLbl.text = "방화"
            }
            if item1 == "6"{
                startLbl.text = "응암"
                endLbl.text = "응암"
            }
            if item1 == "7"{
                startLbl.text = "장암"
                endLbl.text = "장암"
            }
            if item1 == "8"{
                startLbl.text = "암사"
                endLbl.text = "암사"
            }
            if item1 == "9"{
                startLbl.text = "개화"
                endLbl.text = "개화"
            }

            return numLbl.text = lineNumber[row]
        }
            
        else if component == 1 {
            
            
            if numLbl.text == Optional("Label") {
                
                return startLbl.text = lineText[0][row]
            }
                
            else {
                
                return startLbl.text = lineText[Int(numLbl.text!)!-1][row]
            }
        }
            
        else {
            
            if numLbl.text == Optional("Label") {
                
                return endLbl.text = lineText[0][row]
            }
                
            else {
                
                return endLbl.text = lineText[Int(numLbl.text!)!-1][row]
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        alarmModel=Alarms()
        subwaytableView.reloadData()
        //snoozeEnabled = segueInfo.snoozeEnabled
        
//        var one = UIImage(named: "1.png" )
//        image1.image = one
        
        super.viewWillAppear(animated)
    }
    
    
        //return lineSelected.text = lineNumber[row] }
    override func viewDidLoad() {
            
            super.viewDidLoad()
        
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
            print(didAllow) //푸시알림을 허용할지 물어보는 함수
        })


            UNUserNotificationCenter.current().delegate = self //foreground에서 푸시알림이 뜰수 있게 하는 함수

        
            let one = UIImage(named: "1.png" )
            image1.image = one
        
            subwayPicker.delegate = self
            subwayPicker.dataSource = self
            
            numLbl.text = "1"
            startLbl.text = "신설동"
            endLbl.text = "신설동"
        
            segueInfo = SegueInfo(curCellIndex: 0, isEditMode: false, label: "Alarm", mediaLabel: "bell", mediaID: "", repeatWeekdays: [], enabled: false, snoozeEnabled: false)
            
        }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        NotificationCenter.default.addObserver(forName: Start_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 출발역 코드: \(userInfo["data"] as! String)")
            }
        }
        NotificationCenter.default.addObserver(forName: End_code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 도착역 코드: \(userInfo["data"] as! String)")
            }
        }
        NotificationCenter.default.addObserver(forName: Start_sec, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 출발역 떠나는 시간: \(userInfo["data"] as! String)")
              
                print("TRAIN_NO : ",userInfo["data2"] as! String) //train_num을 받아온다
                
                TRAIN_NO = userInfo["data2"] as! String
                self.getCodeByName_arrive(line: self.numLbl.text!)
                time1 = userInfo["data"] as! String
            }
        }
        NotificationCenter.default.addObserver(forName: End_sec, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 도착역 도착 시간: \(userInfo["data"] as! String)")
                time2 = userInfo["data"] as! String
            }
        }
    }
    
        
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

    
    
//tableview 관련
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        var cell = subwaytableView.dequeueReusableCell(withIdentifier: Id.settingIdentifier)

        if(cell == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: Id.settingIdentifier)
            
        }
        
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell!.textLabel!.text = "Sound"
                cell!.detailTextLabel!.text = segueInfo.mediaLabel
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator }
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = subwaytableView.cellForRow(at: indexPath)
        
        if indexPath.section == 0 {
            
            switch indexPath.row{
                
            
            case 0:
                performSegue(withIdentifier: Id.soundSegueIdentifier, sender: self)
                cell?.setSelected(true, animated: false)
                cell?.setSelected(false, animated: false)
                
            default: break
            }
        }
            
        else if indexPath.section == 1 {
            //delete alarm
            alarmModel.alarms.remove(at: segueInfo.curCellIndex)
            performSegue(withIdentifier: Id.saveSegueIdentifier, sender: self)
        }
    }
    
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
            let dist = segue.destination as! firstMediaTableViewController
            dist.mediaID = segueInfo.mediaID
            dist.mediaLabel = segueInfo.mediaLabel
        }
        else if segue.identifier == Id.labelSegueIdentifier {
            let dist = segue.destination as! LabelEditViewController
            dist.label = segueInfo.label
        }
        else if segue.identifier == Id.weekdaysSegueIdentifier {
            let dist = segue.destination as! WeekdaysViewController
            dist.weekdays = segueInfo.repeatWeekdays
        }
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
                
                print("text잘 받니??",self.startLbl.text!)
                for a in 0...station_num.count - 1 {
                    
                    if station_name[a] == self.startLbl.text {  //label의 값을 가져오기 때문에 불안정하다.. 나중에 바꿔주자!!
                        findNum = station_num[a]
                        
                    }
                    
                    
                }
                NotificationCenter.default.post(name: Start_code, object: nil, userInfo:["data":findNum!])
                
                
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
                
                print("text잘 받니??",self.endLbl.text!)
                for a in 0...station_num.count - 1 {
                    
                    if station_name[a] == self.endLbl.text! {
                        findNum = station_num[a]
                        
                    }
                    
                    
                }
                NotificationCenter.default.post(name: End_code, object: nil, userInfo:["data":findNum!])
                
                
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
                
                NotificationCenter.default.post(name: Start_sec, object: nil, userInfo:myDict) //data2에 TRAIN_NO 정보가 들어간다.
                
                
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
                
                NotificationCenter.default.post(name: End_sec, object: nil, userInfo:["data":left_time[0]])
                //원래는 arrive_time[0]으로 해야 정확하지만.... 상행 하행 고려를 해줘야 한다!!
                
                
                
            } catch {
                print("Error~~")
                
            }
        })
        
        task.resume()
        
        
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension frontViewController : UNUserNotificationCenterDelegate{
    //To display notifications when app is running  inforeground
    
    //앱이 foreground에 있을 때. 즉 앱안에 있어도 push알림을 받게 해줍니다.
    //viewDidLoad()에 UNUserNotificationCenter.current().delegate = self를 추가해주는 것을 잊지마세요.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}

