import XCTest
import PostgresClientKit

@testable import CarbonSplitGo

class PostgresConnectTests: XCTestCase {

    //starter test to learn how these horrible swift unit tests work, took too long to learn
    func testGetConnection() {
        do {
            let connection = try PostgresConnect.getConnection()
            XCTAssertNotNil(connection, "If not nil, then it is connected")
        } catch {
            XCTFail("Failed to connect, error: \(error)")
        }
    }
}
