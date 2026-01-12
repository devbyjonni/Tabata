//
//  TimeIntervalTests.swift
//  TabataTests
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import XCTest
@testable import Tabata

final class TimeIntervalTests: XCTestCase {

    func testFormatTime() {
        // Minutes and Seconds
        XCTAssertEqual(TimeInterval(0).formatTime(), "00:00")
        XCTAssertEqual(TimeInterval(59).formatTime(), "00:59")
        XCTAssertEqual(TimeInterval(60).formatTime(), "01:00")
        XCTAssertEqual(TimeInterval(65).formatTime(), "01:05")
        XCTAssertEqual(TimeInterval(3599).formatTime(), "59:59")
        
        // Hours, Minutes, and Seconds
        XCTAssertEqual(TimeInterval(3600).formatTime(), "01:00:00")
        XCTAssertEqual(TimeInterval(3665).formatTime(), "01:01:05")
    }
}
