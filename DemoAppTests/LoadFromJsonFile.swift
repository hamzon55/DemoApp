//
//  LoadFromJsonFile.swift
//  DemoAppTests
//
//  Created by HamZa Jerbi on 21/5/24.
//

import XCTest
@testable import DemoApp
import Foundation


extension Decodable {
    static func parse(jsonFile: String) -> Self? {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let output = try? JSONDecoder().decode(self, from: data)
        else {
            return nil
        }
        
        return output
    }
}
