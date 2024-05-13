//
//  MarvelConstants.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 13/5/24.
//

import Foundation

struct MarvelConstants {
  static let apiKey = "b64b2574549f20514cddfe770e958632"
  static let timestamp: String = "1"
  static let privateKey = "d1f327fa1e86f17f72ed47fd0d88dc3c97276739"
  static let baseUrl = URL(string: "https://gateway.marvel.com:443/v1/public")!
  static let characterPath = "/characters"
  static let hash = "\(timestamp)\(privateKey)\(apiKey)".MD5()
}
