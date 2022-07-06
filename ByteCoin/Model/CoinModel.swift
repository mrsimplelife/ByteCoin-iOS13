//
//  CoinModel.swift
//  ByteCoin
//
//  Created by 박윤철 on 2022/07/06.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let lastPrice: Double
    let currency: String
    var lastPriceString: String {
        return String(format: "%.2f", lastPrice)
    }
}
