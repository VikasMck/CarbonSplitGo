import SwiftUI
import PostgresClientKit

struct LocationQueries {
    static func insertCoordinateToDB(longitude: Double, latitude: Double) async throws {
        let connection = try PostgresConnect.getConnection()
       defer { connection.close() }
       
       let statement = try connection.prepareStatement(
        text: SQLUserQueries.insertUserCoordinates)
       defer { statement.close() }
       
       try statement.execute(parameterValues: [
           Session.shared.getUserID(),
           longitude,
           latitude,
       ])
       print("worked! latitude: \(latitude), longitude: \(longitude)")
    }
}
