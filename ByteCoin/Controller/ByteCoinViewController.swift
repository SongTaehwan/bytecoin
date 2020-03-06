//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ByteCoinViewController: UIViewController {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }


}

// MARK: - UIPickerView
extension ByteCoinViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    // row -> row index, forComponent -> colmn(Picker view) index
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // api
        let currencyString = coinManager.currencyArray[row]
        coinManager.fetchPrice(currency: currencyString)
    }
}

// MARK: - CoinManagerDelegate
extension ByteCoinViewController: CoinMangerDelegate {
    func didFailWithError(_ coinManager: CoinManager, error: Error) {
        print(error)
    }
    
    func didUpdatePrice(_ coinManager: CoinManager, coinModel: CoinModel, currency: String) {
        DispatchQueue.main.async {
            self.priceLabel.text = coinModel.rate
            self.currencyLabel.text = currency
        }
    }
}
