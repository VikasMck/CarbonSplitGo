import SwiftUI
import MapKit

//due to built in Map limitations when routing I needed to create this view. Methods taken, and overriden from UIViewRepresentable
struct CustomMapView: UIViewRepresentable {
    @Binding var mkRoute: MKRoute?
    @Binding var clCoordinates: [CLLocationCoordinate2D?]

    //coordinator is required to handle interactions beenween MKMapView and my CustomMapView
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        init(parent: CustomMapView) {
            self.parent = parent
        }

        //creating a custom renderer
        func mapView(_ mkMapView: MKMapView, rendererFor mkOverlay: MKOverlay) -> MKOverlayRenderer {
            if let mkPolyline = mkOverlay as? MKPolyline {
                let mkRenderer = MKPolylineRenderer(polyline: mkPolyline)
                mkRenderer.strokeColor = .blue
                mkRenderer.lineWidth = 5
                return mkRenderer
            }
            return MKOverlayRenderer(overlay: mkOverlay)
        }
    }

    //part of UIViewRepresentable
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    //part of UIViewRepresentable
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    //part of UIViewRepresentable
    func updateUIView(_ mkMapView: MKMapView, context: Context) {
        mkMapView.removeOverlays(mkMapView.overlays)

        if let start = clCoordinates[0], let middle = clCoordinates[1], let end = clCoordinates[2] {
            let region = MKCoordinateRegion(center: start, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mkMapView.setRegion(region, animated: true)

            routeOverlayOnMap(from: start, to: middle, mapView: mkMapView)
            routeOverlayOnMap(from: middle, to: end, mapView: mkMapView)
        }
    }

    //add an overlay of the route to the map
    private func routeOverlayOnMap(from routeStart: CLLocationCoordinate2D, to routeEnd: CLLocationCoordinate2D, mapView: MKMapView) {
        let mkRequest = MKDirections.Request()
        mkRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: routeStart))
        mkRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: routeEnd))
        
        MKDirections(request: mkRequest).calculate { response, error in
            if let route = response?.routes.first {
                mapView.addOverlay(route.polyline)
            }
        }
    }
}

