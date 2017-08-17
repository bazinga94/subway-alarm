# subway-alarm
첫 commit by jongho

유저디폴트 값 저장과 불러오기
class ViewController: UIViewController {

* 유저디폴트 저장 후 받아오는 방법
class ViewController: UIViewController {

<<<<<<< HEAD

@IBOutlet weak var textfield1: UITextField!

@IBOutlet weak var textfield2: UITextField!

@IBAction func event1(_ sender: Any) {
    //텍스트필드 값 얻어서 유저 디폴트에 저장
    let strValue1 = textfield1.text
    let strValue2 = textfield2.text
    //유저 디폴트에 저장
    let setting = UserDefaults.standard

    setting.set(strValue1, forKey: "strkey1")
    setting.set(strValue2, forKey: "strkey2")
    setting.synchronize()

    }

@IBAction func event2(_ sender: Any) {
    //유저 디폴트에서 값 읽어오기

    let setting = UserDefaults.standard

    let str1 = setting.string(forKey: "strkey1")
    let str2 = setting.string(forKey: "strkey2")
    
    textfield1.text = str1

    textfield2.text = str2

    }
=======
    
    
    @IBOutlet weak var textfield1: UITextField!
    
    @IBOutlet weak var textfield2: UITextField!
    
    @IBAction func event1(_ sender: Any) {
        //텍스트필드 값 얻어서 유저 디폴트에 저장
        let strValue1 = textfield1.text
        let strValue2 = textfield2.text
        //유저 디폴트에 저장
        let setting = UserDefaults.standard
        
        setting.set(strValue1, forKey: "strkey1")
        setting.set(strValue2, forKey: "strkey2")
        setting.synchronize()

    }
    
    @IBAction func event2(_ sender: Any) {
        //유저 디폴트에서 값 읽어오기
        
        let setting = UserDefaults.standard

        let str1 = setting.string(forKey: "strkey1")
        let str2 = setting.string(forKey: "strkey2")
        
        textfield1.text = str1
        
        textfield2.text = str2
        
    }
    
    
    
* plist 받아오는 방법    
    class myTableViewController: UITableViewController {

    var data: [String] = []
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url: URL = Bundle.main.url(forResource: "devices", withExtension: "plist")!
        
        let array = NSArray(contentsOf: url)
        data = array as! [String]


*노티보내는거

let myNoti = NSNotification.Name("Alarm")


class ViewController: UIViewController {

    @IBAction func sendNoti(_ sender: Any) {
        NotificationCenter.default.post(name: myNoti, object: nil, userInfo: ["data" : "Alarm"])
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: myNoti, object: nil, queue: nil) { (noti: Notification) in
            let userInfo = noti.userInfo
            print("user Info : \(userInfo)")
            
    }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

>>>>>>> origin/master
