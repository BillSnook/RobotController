//
//  SpeedTests.swift
//  RobotControllerTests
//
//  Tests for the speed index table (Speed.swift): default table generation,
//  parsing the table sent by the robot, and the left/right accessors used by the UI.
//

import XCTest
@testable import RobotController

final class SpeedTests: XCTestCase {

    private var speed: Speed!

    override func setUp() {
        super.setUp()
        speed = Speed()     // Fresh instance, so tests don't share Speed.shared state
    }

    override func tearDown() {
        speed = nil
        super.tearDown()
    }

    // Builds a device response like "S 8\n-8 l r\n...\n8 l r"
    private func deviceMessage(indexSpace: Int,
                               left: (Int) -> Int,
                               right: (Int) -> Int) -> String {
        var lines = ["S \(indexSpace)"]
        for index in -indexSpace...indexSpace {
            lines.append("\(index) \(left(index)) \(right(index))")
        }
        return lines.joined(separator: "\n")
    }

    // MARK: - SpeedChartEntry

    func testSpeedChartEntryIdIsIndex() {
        let entry = SpeedChartEntry(index: "-3", value: 384)
        XCTAssertEqual(entry.id, "-3")
    }

    // MARK: - Default table

    func testDefaultTableHasEntryForEveryIndex() {
        XCTAssertEqual(speed.left.count, defaultSpeedArrayIndexSpace * 2 + 1)
        XCTAssertEqual(speed.right.count, defaultSpeedArrayIndexSpace * 2 + 1)
    }

    func testDefaultTableIndexesRunFromFullReverseToFullForward() {
        let expected = (-defaultSpeedArrayIndexSpace...defaultSpeedArrayIndexSpace).map { String($0) }
        XCTAssertEqual(speed.left.map(\.index), expected)
        XCTAssertEqual(speed.right.map(\.index), expected)
    }

    func testDefaultTableValuesAreLinearAndSymmetric() {
        for arrayIndex in 0...(defaultSpeedArrayIndexSpace * 2) {
            let displayIndex = arrayIndex - defaultSpeedArrayIndexSpace
            let expected = speedArraySpeedIncrements * abs(displayIndex)
            XCTAssertEqual(speed.left[arrayIndex].value, expected, "left at index \(displayIndex)")
            XCTAssertEqual(speed.right[arrayIndex].value, expected, "right at index \(displayIndex)")
        }
    }

    func testDefaultSelectionIsSlowestForwardSpeed() {
        XCTAssertEqual(speed.internalIndex, defaultSpeedArrayIndexSpace + 1)
        XCTAssertEqual(speed.selectedIndex, 1)
    }

    func testDefaultSetupWithInitialIndex() {
        speed.setup(-3)
        XCTAssertEqual(speed.selectedIndex, -3)
        XCTAssertEqual(speed.internalIndex, defaultSpeedArrayIndexSpace - 3)
    }

    func testSelectedIndexZeroIsStopped() {
        speed.internalIndex = defaultSpeedArrayIndexSpace
        XCTAssertEqual(speed.selectedIndex, 0)
        XCTAssertEqual(speed.leftFloat, 0)
        XCTAssertEqual(speed.rightFloat, 0)
    }

    // MARK: - Accessors for the selected index

    func testFloatAccessorsReadSelectedEntry() {
        speed.internalIndex = defaultSpeedArrayIndexSpace + 4     // selectedIndex 4
        XCTAssertEqual(speed.leftFloat, Float(speedArraySpeedIncrements * 4))
        XCTAssertEqual(speed.rightFloat, Float(speedArraySpeedIncrements * 4))
    }

    func testFloatSettersTruncateAndOnlyChangeSelectedEntry() {
        speed.internalIndex = defaultSpeedArrayIndexSpace + 2
        let otherLeft = speed.left[defaultSpeedArrayIndexSpace + 3].value

        speed.leftFloat = 1000.9
        speed.rightFloat = 2048

        XCTAssertEqual(speed.left[speed.internalIndex].value, 1000)
        XCTAssertEqual(speed.right[speed.internalIndex].value, 2048)
        XCTAssertEqual(speed.left[defaultSpeedArrayIndexSpace + 3].value, otherLeft)
    }

    func testStringAccessorsReadSelectedEntry() {
        speed.internalIndex = defaultSpeedArrayIndexSpace - 2     // selectedIndex -2
        XCTAssertEqual(speed.leftString, String(speedArraySpeedIncrements * 2))
        XCTAssertEqual(speed.rightString, String(speedArraySpeedIncrements * 2))
    }

    func testStringSettersParseNumbers() {
        speed.leftString = "1234"
        speed.rightString = "4095"
        XCTAssertEqual(speed.left[speed.internalIndex].value, 1234)
        XCTAssertEqual(speed.right[speed.internalIndex].value, 4095)
    }

    func testStringSettersUseZeroForInvalidText() {
        speed.leftString = "fast"
        speed.rightString = ""
        XCTAssertEqual(speed.left[speed.internalIndex].value, 0)
        XCTAssertEqual(speed.right[speed.internalIndex].value, 0)
    }

    // MARK: - Table from device

    func testSetupFromDeviceMessageLoadsAllEntries() {
        let message = deviceMessage(indexSpace: 8,
                                    left: { abs($0) * 500 },
                                    right: { abs($0) * 500 + 7 })
        speed.setup(message)

        XCTAssertEqual(speed.left.count, 17)
        XCTAssertEqual(speed.right.count, 17)
        for index in -8...8 {
            let arrayIndex = index + 8
            XCTAssertEqual(speed.left[arrayIndex].index, String(index))
            XCTAssertEqual(speed.left[arrayIndex].value, abs(index) * 500)
            XCTAssertEqual(speed.right[arrayIndex].index, String(index))
            XCTAssertEqual(speed.right[arrayIndex].value, abs(index) * 500 + 7)
        }
        XCTAssertEqual(speed.selectedIndex, 1)
    }

    func testSetupFromDeviceMessageUsesDeviceIndexSpace() {
        let message = deviceMessage(indexSpace: 4, left: { abs($0) * 100 }, right: { abs($0) * 100 })
        speed.setup(message)

        XCTAssertEqual(speed.left.count, 9)
        XCTAssertEqual(speed.right.count, 9)
        XCTAssertEqual(speed.internalIndex, 5)
        XCTAssertEqual(speed.selectedIndex, 1)
        XCTAssertEqual(speed.leftFloat, 100)
        XCTAssertEqual(speed.left.first?.index, "-4")
        XCTAssertEqual(speed.left.last?.index, "4")
    }

    func testSetupFromDeviceMessageWithInitialIndex() {
        let message = deviceMessage(indexSpace: 8, left: { abs($0) }, right: { abs($0) })
        speed.setup(message, -2)
        XCTAssertEqual(speed.selectedIndex, -2)
        XCTAssertEqual(speed.leftFloat, 2)
    }

    func testSetupFromDeviceMessageFallsBackToDefaultIndexSpace() {
        var lines = ["S notANumber"]
        for index in -8...8 { lines.append("\(index) 10 20") }
        speed.setup(lines.joined(separator: "\n"))

        XCTAssertEqual(speed.left.count, defaultSpeedArrayIndexSpace * 2 + 1)
        XCTAssertEqual(speed.left[0].value, 10)
        XCTAssertEqual(speed.right[0].value, 20)
    }

    func testSetupFromDeviceMessageIgnoresBadHeader() {
        let before = speed.left
        speed.setup("S\n1 999 999")
        XCTAssertEqual(speed.left, before)

        speed.setup("S 8 extra\n1 999 999")
        XCTAssertEqual(speed.left, before)
    }

    func testSetupFromDeviceMessageSkipsNonNumericAndOutOfRangeLines() {
        var lines = ["S 8"]
        for index in -8...8 { lines.append("\(index) 50 60") }
        lines.append("x 1 2")           // Non-numeric index
        lines.append("3 fast 2")        // Non-numeric value
        lines.append("-9 777 777")      // Below the table range
        speed.setup(lines.joined(separator: "\n"))

        XCTAssertEqual(speed.left.count, 17)
        XCTAssertTrue(speed.left.allSatisfy { $0.value == 50 })
        XCTAssertTrue(speed.right.allSatisfy { $0.value == 60 })
    }

    // MARK: - Malformed device messages (used to crash)

    func testSetupFromEmptyMessageIsIgnored() {
        let before = speed.left
        speed.setup("")
        speed.setup("\n\n")
        XCTAssertEqual(speed.left, before)
        XCTAssertEqual(speed.selectedIndex, 1)
    }

    func testSetupFromDeviceMessageIgnoresZeroOrNegativeIndexSpace() {
        let before = speed.left
        speed.setup("S 0\n0 0 0")
        XCTAssertEqual(speed.left, before)
        speed.setup("S -3\n1 10 10")
        XCTAssertEqual(speed.left, before)

        // Still accepts the default table afterwards, since nothing was loaded
        speed.setup(-1)
        XCTAssertEqual(speed.selectedIndex, -1)
    }

    func testSetupFromDeviceMessageSkipsShortLines() {
        var lines = ["S 8"]
        for index in -8...8 { lines.append("\(index) 50 60") }
        lines.append("5")               // Index only
        lines.append("5 999")           // Missing right value
        lines.append("   ")             // Blank line
        speed.setup(lines.joined(separator: "\n"))

        XCTAssertEqual(speed.left.count, 17)
        XCTAssertTrue(speed.left.allSatisfy { $0.value == 50 })
        XCTAssertTrue(speed.right.allSatisfy { $0.value == 60 })
    }

    func testSetupFromDeviceMessageSkipsIndexAboveRange() {
        var lines = ["S 4"]
        for index in -4...4 { lines.append("\(index) 50 60") }
        lines.append("5 999 999")       // One past the top of a 4 index table
        lines.append("8 999 999")
        speed.setup(lines.joined(separator: "\n"))

        XCTAssertEqual(speed.left.count, 9)
        XCTAssertTrue(speed.left.allSatisfy { $0.value == 50 })
        XCTAssertTrue(speed.right.allSatisfy { $0.value == 60 })
    }

    func testSetupFromDeviceMessageClampsInitialIndexToTable() {
        let message = deviceMessage(indexSpace: 4, left: { abs($0) }, right: { abs($0) })

        speed.setup(message, 10)
        XCTAssertEqual(speed.selectedIndex, 4)
        XCTAssertEqual(speed.leftFloat, 4)      // Accessor must not go out of range

        speed.setup(message, -10)
        XCTAssertEqual(speed.selectedIndex, -4)
        XCTAssertEqual(speed.rightFloat, 4)
    }

    func testDefaultSetupDoesNotOverwriteDeviceTable() {
        let message = deviceMessage(indexSpace: 8, left: { _ in 42 }, right: { _ in 43 })
        speed.setup(message)
        speed.setup()       // Should be ignored now that we have a device table

        XCTAssertTrue(speed.left.allSatisfy { $0.value == 42 })
        XCTAssertTrue(speed.right.allSatisfy { $0.value == 43 })
    }
}
