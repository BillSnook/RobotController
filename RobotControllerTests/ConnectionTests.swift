//
//  ConnectionTests.swift
//  RobotControllerTests
//
//  Tests for connection state handling in Sender.swift and the device list in ConnectView.swift.
//  These avoid opening real sockets: only paths that don't touch the network are exercised.
//

import XCTest
@testable import RobotController

final class ConnectionStateTests: XCTestCase {

    func testRawValues() {
        XCTAssertEqual(ConnectionState.connected.rawValue, "Connected")
        XCTAssertEqual(ConnectionState.connecting.rawValue, "Connecting")
        XCTAssertEqual(ConnectionState.disconnecting.rawValue, "Disconnecting")
        XCTAssertEqual(ConnectionState.disconnected.rawValue, "Disconnected")
    }

    func testButtonNames() {
        XCTAssertEqual(ConnectionState.connected.buttonName(), "Disconnect")
        XCTAssertEqual(ConnectionState.connecting.buttonName(), "Connecting...")
        XCTAssertEqual(ConnectionState.disconnecting.buttonName(), "Disconnecting...")
        XCTAssertEqual(ConnectionState.disconnected.buttonName(), "Connect")
    }

    func testConnectionRequestRawValues() {
        XCTAssertEqual(ConnectionRequest.connect.rawValue, "Connect")
        XCTAssertEqual(ConnectionRequest.disconnect.rawValue, "Disconnect")
    }
}

final class DevicesTests: XCTestCase {

    func testDeviceIdIsCapitalizedName() {
        XCTAssertEqual(ConnectView.Devices.goofy.id, "Goofy")
        XCTAssertEqual(ConnectView.Devices.develop00.id, "Develop00")
    }

    func testDeviceIdsAreUnique() {
        let ids = ConnectView.Devices.allCases.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
    }
}

final class SenderTests: XCTestCase {

    private var sender: Sender!

    override func setUp() {
        super.setUp()
        sender = Sender()
    }

    override func tearDown() {
        // Mark as disconnected so deinit doesn't try to sign off the device and sleep
        sender.connectionState = .disconnected
        sender = nil
        super.tearDown()
    }

    func testStartResponseReplacesResponseText() {
        sender.startResponse("first")
        sender.startResponse("second")
        XCTAssertEqual(sender.responseString, "second")
    }

    func testSendFailsWhenDisconnected() {
        sender.connectionState = .disconnected
        sender.startResponse("")

        XCTAssertFalse(sender.sendPi("D"))
        XCTAssertEqual(sender.responseString, "\n Socket not connected while sending D")
    }

    func testSendFailsWhileConnecting() {
        sender.connectionState = .connecting
        XCTAssertFalse(sender.sendPi("@"))
    }

    func testConnectWhileConnectedWarns() {
        sender.connectionState = .connected
        sender.requestConnectionStateChange(.connect, "Goofy")

        XCTAssertEqual(sender.responseString, "WARNING - already connected")
        XCTAssertEqual(sender.connectionState, .connected)
    }

    func testDisconnectWhileDisconnectedIsInvalid() {
        sender.connectionState = .disconnected
        sender.requestConnectionStateChange(.disconnect, "Goofy")

        XCTAssertEqual(sender.responseString,
                       "Warning - invalid request received: Disconnect in connection state Disconnected")
        XCTAssertEqual(sender.connectionState, .disconnected)
    }

    func testRequestsWhileConnectingAreInvalid() {
        sender.connectionState = .connecting

        sender.requestConnectionStateChange(.connect, "Goofy")
        XCTAssertEqual(sender.responseString,
                       "Warning - invalid request received: Connect in connection state Connecting")

        sender.requestConnectionStateChange(.disconnect, "Goofy")
        XCTAssertEqual(sender.responseString,
                       "Warning - invalid request received: Disconnect in connection state Connecting")
        XCTAssertEqual(sender.connectionState, .connecting)
    }

    func testRequestsWhileDisconnectingAreInvalid() {
        sender.connectionState = .disconnecting

        sender.requestConnectionStateChange(.connect, "Goofy")
        XCTAssertEqual(sender.responseString,
                       "Warning - invalid request received: Connect in connection state Disconnecting")
        XCTAssertEqual(sender.connectionState, .disconnecting)
    }
}
