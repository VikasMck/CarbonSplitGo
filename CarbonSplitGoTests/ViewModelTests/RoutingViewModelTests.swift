import XCTest
import CoreLocation
import MapKit
@testable import CarbonSplitGo

//this test uses random location, not accurate, only checks if works
final class RoutingViewModelTests: XCTestCase {
    var routingViewModel: RoutingViewModel!

    //same story
    override func setUp() {
        super.setUp()
        routingViewModel = RoutingViewModel()
    }

    override func tearDown() {
        routingViewModel = nil
        super.tearDown()
    }


    func testFetchCoordinates_WithInvalidLocations() async {
        let expectation = self.expectation(description: "Test fails. Invalid address string")
        let locations = ["randomstringpleasedontbeaweirdlocation"]
        
        Task{
            await routingViewModel.fetchCoordinates(from: locations)
            XCTAssertNil(routingViewModel.userCoordinates[0], "Route not created. Location results in nil")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }

    func testCalculateRoutes_WithSinglePoint_ShouldNotCreateRoutes() async {
        let expectation = self.expectation(description: "Test fails. Only one location")
        let locations = ["TUDublin"]
        
        Task{
            await routingViewModel.fetchCoordinates(from: locations)
            XCTAssertTrue(routingViewModel.routes.isEmpty, "Routes should not be only one point")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testCalculateRoutes_WithTwoPoints() async {
        let expectation = self.expectation(description: "Test Passes. Two locations routed")
        let locations = ["Dublin", "Cork"]
        
        Task {
            await routingViewModel.fetchCoordinates(from: locations)
            
            await MainActor.run {
                XCTAssertFalse(routingViewModel.routes.isEmpty, "Routes should not be only one point")
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 5)

    }
    
    func testCalculateRoutes_WithThreePoints() async {
        let expectation = self.expectation(description: "Test Passes. Three locations routed")
        let locations = ["Sligo", "Dublin", "Cork"]
        
        Task{
            await routingViewModel.fetchCoordinates(from: locations)
            XCTAssertFalse(routingViewModel.routes.isEmpty, "Routes should be made with 3 points")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 10)
    }
    
    func testCalculateRoutes_WithTenPoints() async {
        let expectation = self.expectation(description: "Test Passes. Ten locations routed")
        let locations = ["Sligo", "Dublin", "Cork", "Galway", "Limerick", "Killarney", "Waterford", "Belfast", "Wexford", "Letterkenny"]
        
        Task{
            await routingViewModel.fetchCoordinates(from: locations)
            XCTAssertFalse(routingViewModel.routes.isEmpty, "Routes should be made even with 10 points")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 30)
    }
}
