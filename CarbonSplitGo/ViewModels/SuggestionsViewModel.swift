import SwiftUI
import Combine

class SuggestionsViewModel: ObservableObject {
    @Published var mapLocation: [MapLocation] = []
    private var cancellables: Set<AnyCancellable> = [] //lifecycle management from Combine
    
    
    func fetchSuggestionsPlacesAPI(for locationQuery: String) {
        guard !locationQuery.isEmpty else {
            self.mapLocation = []
            return
        }
        
        //google api pain
        let encodedLocationQuery = locationQuery.addingPercentEncoding(withAllowedCharacters:
                .urlQueryAllowed) ?? "" //default to empty string if unsafe
        let urlAPICall = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(encodedLocationQuery)&key=\(Const.API_KEY)"
        
        guard let url = URL(string: urlAPICall) else { return }
        
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data } //emit data
            .decode(type: ResponseSuggestion.self, decoder: JSONDecoder())
            .map { responseSuggestion in
                responseSuggestion.predictions.map { MapLocation(id: $0.place_id, name: $0.description) }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { suggestions in
                self.mapLocation = suggestions
            })
            .store(in: &cancellables) //combine magic
    }
}
