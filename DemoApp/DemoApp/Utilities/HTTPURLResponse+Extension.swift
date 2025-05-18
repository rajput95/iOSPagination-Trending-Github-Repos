//
//  HTTPURLResponse+Extension.swift
//  DemoApp
//
//  Created by Moin Rajput on 10/10/2021.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
