//
//  Api_notificationCenter.swift
//  Alarm-ios-swift
//
//  Created by cscoi008 on 2017. 8. 17..
//  Copyright © 2017년 LongGames. All rights reserved.
//
/*
import UIKit
import Foundation
import UserNotifications // 로컬 푸시 권한 요청
/*
 import PlaygroundSupport
 PlaygroundPage.current.needsIndefititeExecution = true
 */
/*
let Depart_Code = NSNotification.Name("TaskDone")
let Arrive_Code = NSNotification.Name("TaskDone2")
let Depart_Sec = NSNotification.Name("TaskDone3")
let Arrive_Sec = NSNotification.Name("TaskDone4")
*/
/*
let dateFormatter = DateFormatter()

//let date = "17:18:59"
var time1: String = " "
var time2: String = " "
*/
/*
var departNum: String = "디폴트"
var arriveNum: String = "디폴트2"  // 시간을 계산하기 위해 받아와야하는 역 이름 변수들 + 디폴트 값을 안 만들었더니 에러가 생겨서...
*/
class ViewController: UIViewController {
    
    var findNumArray : Array<String> = Array<String>() //findNum 을 삽입 할 배열을 만들어보자.....
    
    //var line = "6"
    
    @IBOutlet weak var textValue: UITextField!
    @IBOutlet weak var textValue2: UITextField!
    
    @IBAction func noti(_ sender: AnyObject) { //역코드 확인 버튼 누를 시 함수
        
        getCodeByName_depart(line: "6")  //나중에 line 값을 따로 받게 하자
        getCodeByName_arrive(line: "6")
        
        
        NotificationCenter.default.addObserver(forName: Depart_Code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                departNum = userInfo["data"] as! String
                
                self.departSec(departNum: departNum) // 만약 noti가 departNum을 받으면 departSec함수에 집어넣어서 실행 시킨다
                
            }
        }
        
        NotificationCenter.default.addObserver(forName: Arrive_Code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                arriveNum = userInfo["data"] as! String
                
                self.arriveSec(arriveNum: arriveNum) // 만약 noti가 departNum을 받으면 arriveSec함수에 집어넣어서 실행 시킨다
                
            }
        }
        
        
    }
    
    
    
    
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
                
                print("text잘 받니??",self.textValue.text!)
                for a in 0...station_num.count - 1 {
                    
                    if station_name[a] == self.textValue.text {
                       findNum = station_num[a]
                        
                    }
                    
                    
                }
                NotificationCenter.default.post(name: Depart_Code, object: nil, userInfo:["data":findNum!])
                
                
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
                
                print("text잘 받니??",self.textValue2.text!)
                for a in 0...station_num.count - 1 {
                    
                    if station_name[a] == self.textValue2.text {
                       findNum = station_num[a]
                        
                    }
                    
                    
                }
                NotificationCenter.default.post(name: Arrive_Code, object: nil, userInfo:["data":findNum!])
                
                
            } catch {
                print("Error~~")
            }
            
            
            
            
            
        })//task 닫음, 여기까지 task 선언임...
        
        
        task.resume() //task 실행
        
        
        
    }  //getCodeByName_arrive 함수 끝
    
    func departSec(departNum: String) {
        
        let urlPath = "http://openapi.seoul.go.kr:8088/4f6142724a62617a38346769687741/json/SearchSTNTimeTableByFRCodeService/1/100/\(departNum)/1/1/"
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
                
                
                var startIndex : String.Index = arriveNum.startIndex
                
                // 첫번째 글자에 대한 Index
                let char_first = arriveNum[startIndex]
                let trainNum = String(char_first) + "020"
                
                
                
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
                
                
                
                NotificationCenter.default.post(name: Depart_Sec, object: nil, userInfo:["data":left_time[0]])
                
                
                
                
                
            } catch {
                print("Error~~")
                
            }
        })
        
        task.resume()
        
        
        
        
    }
    
    func arriveSec(arriveNum: String) {  //train number 가져와서 계산
        
        let urlPath = "http://openapi.seoul.go.kr:8088/4f6142724a62617a38346769687741/json/SearchSTNTimeTableByFRCodeService/1/100/\(arriveNum)/1/1/"
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
                
                
                var startIndex : String.Index = arriveNum.startIndex
                
                // 첫번째 글자에 대한 Index
                let char_first = arriveNum[startIndex]
                let trainNum = String(char_first) + "020"
                
                
                
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
                
                NotificationCenter.default.post(name: Arrive_Sec, object: nil, userInfo:["data":arrive_time[0]])
                
                
                
                
            } catch {
                print("Error~~")
                
            }
        })
        
        task.resume()
        
        
        
        
    }
    
    @IBAction func time_diff(_ sender: Any) {  //시간계산 버튼
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let resultDate1 = dateFormatter.date(from: time1)
        let resultDate2 = dateFormatter.date(from: time2)
        
        
        var diffsec = resultDate2!.timeIntervalSince(resultDate1!)
        print("시간 차이는?? : \(abs(diffsec)) 초")
        
        //--------------------------------푸시알림 함수----------------------------------------
        let content = UNMutableNotificationContent()
        content.title = "출발역 : \(textValue.text!)" //"This is title"
        content.subtitle = "도착역 : \(textValue2.text!)" //"This is Subtitle"
        content.body = "\(abs(diffsec))초 걸림.... 빨리 내려!!!!!!!!!"
        content.badge = 1  //앱 아이콘에 알림 표시 추가 함
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil )
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        NotificationCenter.default.addObserver(forName: Depart_Code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 출발역 코드: \(userInfo["data"] as! String)")
            }
        }
        NotificationCenter.default.addObserver(forName: Arrive_Code, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 도착역 코드: \(userInfo["data"] as! String)")
            }
        }
        NotificationCenter.default.addObserver(forName: Depart_Sec, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 출발역 떠나는 시간: \(userInfo["data"] as! String)")
                time1 = userInfo["data"] as! String
            }
        }
        NotificationCenter.default.addObserver(forName: Arrive_Sec, object: nil, queue: nil) { (noti: Notification) in
            if let userInfo = noti.userInfo {
                print("noti가 알려주는 도착역 도착 시간: \(userInfo["data"] as! String)")
                time2 = userInfo["data"] as! String
            }
        }
        
        
        
        
        /*
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "HH:mm:ss"
         //let date = "17:18:59"
         
         
         let resultDate1 = dateFormatter.date(from: arrive_time[0])
         let resultDate2 = dateFormatter.date(from: left_time[0])
         
         
         var diffsec = resultDate2!.timeIntervalSince(resultDate1!)
         print("시간 차이는?? : ",diffsec)
         */
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
            print(didAllow) //푸시알림을 허용할지 물어보는 함수
        })
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
/*
extension ViewController : UNUserNotificationCenterDelegate{
    //To display notifications when app is running  inforeground
    
    //앱이 foreground에 있을 때. 즉 앱안에 있어도 push알림을 받게 해줍니다.
    //viewDidLoad()에 UNUserNotificationCenter.current().delegate = self를 추가해주는 것을 잊지마세요.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
}*/
*/
