import SwiftUI
import PostgresClientKit

struct TestTableView: View {
    @State private var items: [String] = []
    
    
    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
        .onAppear {
            fetchItems()
        }
    }
    
    func fetchItems() {
        Task {
            do {
                var configuration = PostgresClientKit.ConnectionConfiguration()
                configuration.host = "48.209.49.220"
                configuration.database = "carbonsplitgodb"
                configuration.user = "vikas"
                configuration.credential = .scramSHA256(password: "password11")
                
                let connection = try Connection(configuration: configuration)
                defer { connection.close() }
                
                let statement = try connection.prepareStatement(text: "SELECT * FROM test")
                defer { statement.close() }
                
                let cursor = try statement.execute()
                defer { cursor.close() }
                
                var tempItems: [String] = []
                for row in cursor {
                    let columns = try row.get().columns
                   
                    let item = try columns[0].string()
                    tempItems.append(item)
                }
                await MainActor.run {
                    self.items = tempItems
                }
            } catch {
                print("Database error: \(error)")
            }
        }
    }
}
#Preview {
    TestTableView()
}
