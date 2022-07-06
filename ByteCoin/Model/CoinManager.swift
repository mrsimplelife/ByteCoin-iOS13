//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    var delegate: CoinManagerDelegate?

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = ""

    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, res, error) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    // let dataString = String(data: safeData, encoding: .utf8)
                    if let coin = parseJson(safeData) {
                        delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            })
            task.resume()
        }
    }
    func parseJson(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let currency = decodedData.asset_id_quote
            let coin = CoinModel(lastPrice: lastPrice, currency: currency)
            return coin
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}

//MARK: - CoinManagerDelegate
protocol CoinManagerDelegate {
    func didUpdateCoin(_ manager: CoinManager, coin: CoinModel)
    func didFailWithError(_ error: Error)
}
