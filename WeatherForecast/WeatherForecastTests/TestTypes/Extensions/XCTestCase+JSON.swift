//
//  XCTestCase+JSON.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import XCTest

extension XCTestCase {
    enum TestError: Error {
        case fileNotFound
    }
  
    func getData(fromJSON fileName: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("Missing File: \(fileName).json")
                throw TestError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw error
        }
    }
}
