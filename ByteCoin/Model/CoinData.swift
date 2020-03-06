//
//  CoinData.swift
//  ByteCoin
//
//  Created by 송태환 on 2020/03/06.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let time: String
    let rate: Double
    let asset_id_quote: String
}
