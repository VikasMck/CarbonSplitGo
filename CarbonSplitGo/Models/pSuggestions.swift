struct MapLocation: Identifiable {
    let id: String
    let name: String
}

//variable naming has to be exact because...google
struct ResponseSuggestion: Codable {
    let predictions: [PlacePrediction]
    
}
struct PlacePrediction: Codable {
    let description: String
    let place_id: String
}
