//
//  MainAlarmViewController.swift
//  Alarm-ios-swift
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import MediaPlayer
import UserNotifications // 로컬 푸시 권한 요청

class MainAlarmViewController: UITableViewController, AVAudioPlayerDelegate{
   
    var alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmModel: Alarms = Alarms()
    
    var audioPlayer: AVAudioPlayer? //알람때문에
    var soundTimer: Timer = Timer() //소리 알람을 위해
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmScheduler.checkNotification()
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarmModel = Alarms()
        tableView.reloadData()
        //dynamically append the edit button
        if alarmModel.count != 0 {
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if alarmModel.count == 0 {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        return alarmModel.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            performSegue(withIdentifier: Id.editSegueIdentifier, sender: SegueInfo(curCellIndex: indexPath.row, isEditMode: true, label: alarmModel.alarms[indexPath.row].label, mediaLabel: alarmModel.alarms[indexPath.row].mediaLabel, mediaID: alarmModel.alarms[indexPath.row].mediaID, repeatWeekdays: alarmModel.alarms[indexPath.row].repeatWeekdays, enabled: alarmModel.alarms[indexPath.row].enabled, snoozeEnabled: alarmModel.alarms[indexPath.row].snoozeEnabled))
        }
    }
//    var favoriteArray : Array<NSMutableAttributedString> = Array<NSMutableAttributedString>()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Id.alarmCellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: Id.alarmCellIdentifier)
        }
        //cell text
        cell!.selectionStyle = .none
        cell!.tag = indexPath.row
        let alarm: Alarm = alarmModel.alarms[indexPath.row]
        let amAttr: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)]
        let str = NSMutableAttributedString(string: alarm.formattedTime, attributes: amAttr)
        let timeAttr: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)]
        str.addAttributes(timeAttr, range: NSMakeRange(0, str.length))
        
        
//        favoriteArray.append(str)
//        print(favoriteArray[indexPath.row])
//        
//        let station_name = favoriteArray[indexPath.row]
//        cell!.textLabel?.attributedText = station_name
     
       
//        let imgnum = NSMutableAttributedString(string: alarm.formattedLine)
//      
    
//        var favoriteArray : Array<NSMutableAttributedString> = Array<NSMutableAttributedString>()
//                favoriteArray.append(imgnum)
//               print(favoriteArray)
       
        //셀에 이미지 뷰 넣기
        let imageView = UIImageView(frame: CGRect())
        imageView.transform = CGAffineTransform(scaleX: 1, y: 1)   //원래 코드!!!
        
        //let screenSize: CGRect = UIScreen.main.bounds
        //let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        //imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        
     
        //imageView.frame = CGRect(x: 0, y: 0, width: 10, height: screenSize.height * 0.2)
        //let imageView = UIImageView(frame: CGRect(100, 150, 150, 150)); // set as you want
        //var image = UIImage(named: "myImage.png");
        //imageView.image = image;
        
        
        
        // 알람모델의 라인 imgnum에 받아오기
        let imgnum: String = alarm.formattedLine
        
        //셀에 이미지 추가
        cell!.imageView?.image = UIImage(named: "\(imgnum).png")


        //셀에 string 넣기
        cell!.textLabel?.attributedText = str
        cell!.detailTextLabel?.text = ""
        
        //셀에 button 넣기
        let start_button = UIButton(type: UIButtonType.system)
        start_button.frame = CGRect(x: 240, y: 35, width: 60, height: 20)
        //start_button.backgroundColor = UIColor.blue
        start_button.setTitle("Start", for: UIControlState.normal)
        start_button.addTarget(self, action:#selector(start_buttonTouched(sender:)), for: .touchUpInside)
            
        cell?.addSubview(start_button)
        
        let reset_button = UIButton(type: UIButtonType.system)
        reset_button.frame = CGRect(x: 300, y: 35, width: 60, height: 20)
        //button.backgroundColor = UIColor.green
        reset_button.setTitle("Reset", for: UIControlState.normal)
        reset_button.addTarget(self, action:#selector(reset_buttonTouched(sender:)), for: .touchUpInside)
        
        cell?.addSubview(reset_button)

//        //append switch button
//        let sw = UISwitch(frame: CGRect())
//        sw.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
//        
//        //tag is used to indicate which row had been touched
//        sw.tag = indexPath.row
//        sw.addTarget(self, action: #selector(MainAlarmViewController.switchTapped(_:)), for: UIControlEvents.valueChanged)
//        if alarm.enabled {
//            cell!.backgroundColor = UIColor.white
//            cell!.textLabel?.alpha = 1.0
//            cell!.detailTextLabel?.alpha = 1.0
//            sw.setOn(true, animated: false)
//        } else {
//            cell!.backgroundColor = UIColor.groupTableViewBackground
//            cell!.textLabel?.alpha = 0.5
//            cell!.detailTextLabel?.alpha = 0.5
//        }
//        cell!.accessoryView = sw
        
        //delete empty seperator line
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell!
    }
    
    func start_buttonTouched(sender:UIButton!)  //button 클릭시 실행 함수
        {
          print("Start Button Target Action Works!!!")
            //---------------------------------alert 생성 함수------------------------
            let alertController = UIAlertController(title: "출발: 안암 \n도착: 고려대", message: "알람을 켜시겠습니까?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                //Cancel 버튼을 눌렀을때 실행 함수
            }
            alertController.addAction(cancelAction)
            
            let destroyAction = UIAlertAction(title: "Start", style: .destructive) { action in
                //Start 버튼을 눌렀을때 실행 하는 시간 계산 함수
                
                
                dateFormatter.dateFormat = "HH:mm:ss"
                //let resultDate1 = dateFormatter.date(from: self.time1)
                //let resultDate2 = dateFormatter.date(from: self.time2)
                
                
                let diffsec: Double = 5//resultDate2!.timeIntervalSince(resultDate1!) - 60 // 60초를 빼주는 이유는 여유있게 알람이 울리도록 하기위해
                print("시간 차이는?? : \(abs(diffsec)) 초")
                //self.seconds = abs(Int(diffsec))
                //self.runTimer()//에러가 발생한다????
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
                content.title = "출발역 : 안암" //"This is title"
                content.subtitle = "도착역 : 고려대" //"This is Subtitle"
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

            
//        for k in 0...alarmModel.alarms.count - 1 {
//        var alarm: Alarm = alarmModel.alarms[k]  //원래는 0 대신indexPath.row 임
//
//        var time = alarm.formattedDepart
//
//        print("time잘 받는지??\(time)")
//        }
        
      }
    
    func reset_buttonTouched(sender:UIButton!) {
        
        print("Reset Button Target Action Works!!!")
        soundTimer.invalidate()  //소리 나는 알람 취소/정지 해주는 함수
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timerdone"]) //push알림도 제거하는 함수!
        if audioPlayer?.play() == true {
            self.audioPlayer!.stop() //알람을 멈추는 함수 테스트용!! 나중에 지워야함 ~초뒤에 울릴 알람을 제거하는게 아니라 소리 알람을 멈춤....
        } //소리알람이 실행 중일때만 멈추게함
        
        let alertController = UIAlertController(title: "출발: 안암 \n도착: 고려대", message: "알람이 종료되었습니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { action in
            //Cancel 버튼을 눌렀을때 실행 함수
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            // 이게 있어야 alert가 생긴다
        }

    }
    
    
//    @IBAction func switchTapped(_ sender: UISwitch) {
//        let index = sender.tag
//        alarmModel.alarms[index].enabled = sender.isOn
//        if sender.isOn {
//            print("switch on")
//            alarmScheduler.setNotificationWithDate(alarmModel.alarms[index].date, onWeekdaysForNotify: alarmModel.alarms[index].repeatWeekdays, snoozeEnabled: alarmModel.alarms[index].snoozeEnabled, onSnooze: false, soundName: alarmModel.alarms[index].mediaLabel, index: index)
//            tableView.reloadData()
//        }
//        else {
//            print("switch off")
//            alarmScheduler.reSchedule()
//            tableView.reloadData()
//        }
//    }
    
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
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            alarmModel.alarms.remove(at: index)
//            let cells = tableView.visibleCells
//            for cell in cells {
//                let sw = cell.accessoryView as! UISwitch
//                //adjust saved index when row deleted
//                if sw.tag > index {
//                    sw.tag -= 1
//                }
//            }
            if alarmModel.count == 0 {
                self.navigationItem.leftBarButtonItem = nil
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            alarmScheduler.reSchedule()
        }   
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dist = segue.destination as! UINavigationController
        let addEditController = dist.topViewController as! AlarmAddEditViewController
        if segue.identifier == Id.addSegueIdentifier {
            addEditController.navigationItem.title = "Add Alarm"
            addEditController.segueInfo = SegueInfo(curCellIndex: alarmModel.count, isEditMode: false, label: "Alarm", mediaLabel: "bell", mediaID: "", repeatWeekdays: [], enabled: false, snoozeEnabled: false)
        }
        else if segue.identifier == Id.editSegueIdentifier {
            addEditController.navigationItem.title = "Edit Alarm"
            addEditController.segueInfo = sender as! SegueInfo
        }
    }
    
    @IBAction func unwindFromAddEditAlarmView(_ segue: UIStoryboardSegue) {
        isEditing = false
    }
    
    public func changeSwitchButtonState(index: Int) {
        //let info = notification.userInfo as! [String: AnyObject]
        //let index: Int = info["index"] as! Int
        alarmModel = Alarms()
        if alarmModel.alarms[index].repeatWeekdays.isEmpty {
            alarmModel.alarms[index].enabled = false
        }
        let cells = tableView.visibleCells
//        for cell in cells {
//            if cell.tag == index {
//                let sw = cell.accessoryView as! UISwitch
//                if alarmModel.alarms[index].repeatWeekdays.isEmpty {
//                    sw.setOn(false, animated: false)
//                    cell.backgroundColor = UIColor.groupTableViewBackground
//                    cell.textLabel?.alpha = 0.5
//                    cell.detailTextLabel?.alpha = 0.5
//                }
//            }
//        }
    }

}

