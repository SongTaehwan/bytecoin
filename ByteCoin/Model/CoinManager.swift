//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinMangerDelegate {
    func didFailWithError(_ coinManager: CoinManager, error: Error)
    func didUpdatePrice(_ coinManager: CoinManager, coinModel: CoinModel)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "API_KEY"
    
    let currencyArray = ["KRW", "AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinMangerDelegate?
    
    func fetchPrice(currency: String) -> Void {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(url)
        performRequest(url)
    }
    
    func performRequest(_ urlString: String) {
        // Create url
        if let url = URL(string: urlString) {
            // Create URLSession
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(self, error: error!)
                }
                
                if let safeData = data {
                    if let coinModel = self.parseJSON(safeData) {
                        self.delegate?.didUpdatePrice(self, coinModel: coinModel)
                    }
                }
            }
            
            dataTask.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()

        do {
            let result = try decoder.decode(CoinData.self, from: data)
            return CoinModel(date: result.time, rate: String(format: "%.2f", result.rate), currency: result.asset_id_quote)
        } catch {
            delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
}
