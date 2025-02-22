import SwiftUI
import MapKit

//makes eatch annotation custom
extension MKPointAnnotation: @retroactive Identifiable {
    public var id: UUID {
        UUID() 
    }
}


//due to built in Map limitations when routing I needed to create this view. Methods taken, and overriden from UIViewRepresentable
@MainActor
struct CustomMapView: UIViewRepresentable {
    var routes: [MKRoute] //changed to be an array, as it will handle multiple routes

    //I need to start using binding more
    @Binding var annotations: [MKPointAnnotation]
    @Binding var selectedAnnotation: MKPointAnnotation?

    //coordinator is required to handle interactions beenween MKMapView and my CustomMapView
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        init(parent: CustomMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? MKPointAnnotation else { return }
            parent.selectedAnnotation = annotation
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            parent.selectedAnnotation = nil
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

    //changed to be simpler, and more usable, as previous way had issues with 2 points only, for info, this, like other UIRepresentables are called by SwiftUI automatically
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        for route in routes {
            mapView.addOverlay(route.polyline)
        }

        //added this so it feels more finished when route is mapped
        if let firstRoute = routes.first {
            let routeRect = firstRoute.polyline.boundingMapRect
            mapView.setVisibleMapRect(routeRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }

        //so this needs to be like this, otherwise it won't on real devices.................
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
}
