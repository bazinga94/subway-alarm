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
    let lineText: [[String]] = [["신설동역", "동묘앞역", "동대문역", "종로5가역"], ["시청역", "을지로입구역", "을지로3가역", "을지로4가역", "동대문역사문화공원역", "신당역", "상왕십리역", "왕십리역"], ["대화역", "주엽역", "정발산역", "마두역", "백석역", "대곡역", "화정역", "원당역", "삼송역", "지축역"], ["당고개역", "상계역", "노원역", "창동역", "쌍문역", "수유역"], ["방화역", "개화산역", "김포공항역", "송정역", "마곡역", "발산역"], ["응암역", "역촌역", "불광역", "독바위역", "연신내역", "구산역", "응암역", "새절역"], ["장암역", "도봉산역", "수락산역", "마들역", "노원역", "중계역", "하계역"], ["암사역", "천호역", "강동구청역", "몽촌토성역", "잠실역", "석촌역", "송파역", "가락시장역"], ["개화역", "김포공항역", "공항시장역", "신방화역", "양천향교", "가양역", "중미역"]]
    
    
    
    
    
    
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
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        alarmModel=Alarms()
        tableView.reloadData()
        snoozeEnabled = segueInfo.snoozeEnabled
        lineLbl.text = "1"
        departLbl.text = "신설동역"
        arriveLbl.text = "신설동역"
        
        var one = UIImage(named: "1.png" )
        image2.image = one
        
        super.viewWillAppear(animated)
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
    
    
}
