MVVM architecture

For fun
Hours: 188

Few comments due to functional naming

Libraries:
    - SwiftUI
    - MapKit
    - CoreLocation
    - Combine
    - Foundation
    - PostgresClientKit
    - CryptoKit
    - BackgroundTasks
    - XCTest
    
APIs:
    - PlacesAPI


(For myself and if someone is confused)
Naming:
    Variables/Functions:
     - Start with lower case
     - camelCase
     
    Classes/Structures:
     - Start with upper case
     - CamelCase

    Protocols:
     - Start with {
     - *Delagates: if delagate just add to the end (exampleDelegate)

    ViewModels:
     - *ViewModel: specific feature for the view (ExampleViewModel)
     - Variables same as classes just lower case (exampleViewModel = ExampleViewModel)
     
    View:
    - *View: - For each screen (ExampleView)
    
    Raw SQL:
    - Starts with SQL (SQLExample)
    
    SQL Processing:
    - End with Queries (ExampleQueries)
    

