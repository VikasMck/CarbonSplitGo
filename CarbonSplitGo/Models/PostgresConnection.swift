import PostgresClientKit

//added for clarity, and mainly tests
protocol PostgresConnection {
    static func getConnection() throws -> PostgresConnection
}
