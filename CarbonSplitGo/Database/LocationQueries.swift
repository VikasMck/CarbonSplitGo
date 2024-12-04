import SwiftUI
import PostgresClientKit

struct LocationQueries {
    private static let configuration: PostgresClientKit.ConnectionConfiguration = {
          var config = PostgresClientKit.ConnectionConfiguration()
          config.host = Const.DB_HOST
          config.database = Const.DB_DATABASE
          config.user = Const.DB_USER
          config.credential = .scramSHA256(password: Const.DB_PASSWORD)
          return config
      }()
    
    static func insertCoordinateToDB(longitude: Double, latitude: Double) async throws {
        let connection = try Connection(configuration: configuration)
        defer { connection.close() }
        
        let statement = try connection.prepareStatement(
            text: "INSERT INTO coordinates (location) VALUES (ST_SetSRID(ST_Point($1, $2), 4326))"
        )
        defer { statement.close() }
        
        try statement.execute(parameterValues: [longitude, latitude])
        print("worked! latitude: \(latitude), longitude: \(longitude)")
    }
}
