//
//  APIResponseError.swift
//  DemoApp
//
//  Created by Moin Rajput on 08/10/2021.
//

import Foundation

enum APIResponseError: Error {
  case network
  case decoding
  
  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data "
    case .decoding:
      return "An error occurred while decoding data"
    }
  }
}
