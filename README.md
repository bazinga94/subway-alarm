# subway-alarm
첫 commit by jongho

이종호
이재택
김세중


class ViewController: UIViewController {

    
    
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
