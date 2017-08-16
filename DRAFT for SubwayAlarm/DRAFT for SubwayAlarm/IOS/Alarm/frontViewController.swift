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


class frontViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    var resumeTapped = false
    
    var seconds = 60 // this variable will hold a starting value of seconds. it could be any amount above 0
    
    var timer = Timer()
    var isTimerRunning = false// this will be used to make sure only one timer is created at a time

    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            self.startButton.isEnabled = false
        }

    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        seconds = 60 //
        
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        startButton.isEnabled = true
        //pauseButton.isEnabled = false
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: (#selector(frontViewController.updateTimer)), userInfo: nil, repeats: true)
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

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var subwayPicker: UIPickerView!
    @IBOutlet weak var subwaytableView: UITableView!
    
    @IBOutlet weak var numLbl: UILabel!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var endLbl: UILabel!
    
    
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmModel: Alarms = Alarms()
    var segueInfo: SegueInfo!
    var snoozeEnabled: Bool = false
    var enabled: Bool!
    
    
    let lineNumber:[String] = ["1","2","3","4","5","6","7","8","9"]
    
    let lineText: [[String]] = [
        ["신설동역", "동묘앞역", "동대문역", "종로5가역"],
        ["시청역", "을지로입구역", "을지로3가역", "을지로4가역", "동대문역사문화공원역", "신당역", "상왕십리 역", "왕십리역"],
        ["대화역", "주엽역", "정발산역", "마두역", "백석역", "대곡역", "화정역", "원 당역", "삼송역", "지축역"],
        ["당고개역", "상계역", "노원역", "창동역", "쌍문역", "수유역"],
        ["방화역", "개화산역", "김포공항역", "송정역", "마곡역", "발산역"],
        ["응암역", "역촌역", "불 광역", "독바위역", "연신내역", "구산역", "응암역", "새절역"],
        ["장암역", "도봉산역", "수락산 역", "마들역", "노원역", "중계역", "하계역"],
        ["암사역", "천호역", "강동구청역", "몽촌토성역", "잠실역", "석촌역", "송파역", "가락시장역"],
        ["개화역", "김포공항역", "공항시장역", "신방화 역", "양천향교", "가양역", "중미역"]
    ]
    
    
    //선택기보기의 열 설정 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 }
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
        
        //let indexselect = pickerView.selectedRow(inComponent: 0)
        
        if component == 0 {
            
            return lineNumber[row] }
            
        else if component == 1 {
            //
            let indexselect = pickerView.selectedRow(inComponent: 0)
            return lineText[indexselect][row]
        }
            
        else{
            // 
            let indexselect = pickerView.selectedRow(inComponent: 0)
            return lineText[indexselect][row]
        }
    
    }
    //초기화
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            
            var item1 = lineNumber[row]
            
            var one = UIImage(named: "1.png" )
            var two = UIImage(named: "2.png" )
            var three = UIImage(named: "3.png" )
            var four = UIImage(named: "4.png" )
            var five = UIImage(named: "5.png" )
            var six = UIImage(named: "6.png" )
            var seven = UIImage(named: "7.png" )
            var eight = UIImage(named: "8.png" )
            var nine = UIImage(named: "9.png" )
            
            
            
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
        
        
        var one = UIImage(named: "1.png" )
        image1.image = one
        
        super.viewWillAppear(animated)
    }
    
    
        //return lineSelected.text = lineNumber[row] }
    override func viewDidLoad() {
            
            super.viewDidLoad()
            subwayPicker.delegate = self
            subwayPicker.dataSource = self
            
            numLbl.text = "1"
            startLbl.text = "신설동역"
            endLbl.text = "신설동역"
            
        }
        
        
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        return 2
    }
        else {
            return 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = subwaytableView.dequeueReusableCell(withIdentifier: Id.settingIdentifier)
        
        if(cell == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: Id.settingIdentifier)
            
        }
        
        
        if indexPath.section == 0 {
            
            
                
                
            if indexPath.row == 0 {
                cell!.textLabel!.text = "Sound"
                
                cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator }
                
                
            else if indexPath.row == 1 {
                cell!.textLabel!.text = "Snooze"
                
                
                let sw = UISwitch(frame: CGRect())
                sw.addTarget(self, action:
                    #selector(AlarmAddEditViewController.snoozeSwitchTapped(_:)), for: UIControlEvents.touchUpInside)
                
                
                if snoozeEnabled {
                    sw.setOn(true, animated: false)
                    
                }
                
                cell!.accessoryView = sw
            }
        }
            
        else if indexPath.section == 1 {
            
            cell = UITableViewCell(
                style: UITableViewCellStyle.default, reuseIdentifier:
                Id.settingIdentifier)
            
            cell!.textLabel!.text = "Delete Alarm"
            cell!.textLabel!.textAlignment = .center
            cell!.textLabel!.textColor = UIColor.red
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
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
    
    
    @IBAction func snoozeSwitchTapped (_ sender: UISwitch) {
        
        snoozeEnabled = sender.isOn
    }
    
   
    
    @IBAction func unwindFromFirstMediaView(_ segue: UIStoryboardSegue) {
        let src = segue.source as! firstMediaTableViewController
//        segueInfo.mediaLabel = src.mediaLabel
//        segueInfo.mediaID = src.mediaID
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
