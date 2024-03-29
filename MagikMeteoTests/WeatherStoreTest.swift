//
//  WeatherStoreTest.swift
//  MagikMeteoTests
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

@testable import MagikMeteo
import XCTest

class WeatherStoreMock: WeatherStore {

    override var storeFileName: String {
        get {
            return "testStoreFileName.json"
        }
    }
}

class WeatherStoreTest: XCTestCase {


    func testDecodable() {

        guard let path = Bundle(for: WeatherStoreTest.self).path(forResource: "responseSample", ofType: "json") else {
            XCTFail()
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let store = try JSONDecoder().decode(WeatherStore.self, from: data)

            XCTAssertEqual(store.allEntries.count, 64)

        } catch let decodingError as DecodingError {
            XCTFail(decodingError.errorDescription ?? "")
        } catch let e {
            XCTFail(e.localizedDescription)
        }
    }
    

    func testDiskSerialization() {

        guard let path = Bundle(for: WeatherStoreTest.self).path(forResource: "responseSample", ofType: "json") else {
            XCTFail()
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let store = try JSONDecoder().decode(WeatherStoreMock.self, from: data)
            try store.saveToDisk()

            let weatherStoreFromDisk = WeatherStoreMock()
            try weatherStoreFromDisk.loadFromDisk()

            XCTAssertEqual(store, weatherStoreFromDisk)

        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
}
