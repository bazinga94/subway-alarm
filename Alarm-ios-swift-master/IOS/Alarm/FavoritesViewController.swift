//
//  FavoritesViewController.swift
//  Alarm-ios-swift
//
//  Created by cscoi023 on 2017. 8. 9..
//  Copyright © 2017년 LongGames. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let theLinePickerData = [String](arrayLiteral: "1", "2", "3", "4", "5", "6", "7", "8", "9")

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return theLinePickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return theLinePickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lineTextField.text = theLinePickerData[row]
    }
    
    @IBOutlet weak var lineTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theLinePicker = UIPickerView()
        lineTextField.inputView = theLinePicker
        theLinePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
