import SwiftUI
import MapKit

//makes eatch annotation custom
extension MKPointAnnotation: @retroactive Identifiable {
    public var id: UUID {
        UUID()
    }
}

//due to facing complications, this helper makes it much easier with handling selection and ids
class RoutePolylineHelper: MKPolyline {
    var isSelected: Bool = false
    var routeID: Int = -1
    var distance: Double = 0.0
    //next commit
    var tripTime: String = ""
    var tollCount: Int = 0
    
    //logic for creating the lines, this is needed when I am using multiple annotations, so it routes from A->last point, rathen than stopping at first point.
    static func from(polyline: MKPolyline, routeID: Int) -> RoutePolylineHelper {
        let pointsStart = polyline.points()
        let points = Array(UnsafeBufferPointer(start: pointsStart, count: polyline.pointCount))
        
        //create a variable which can be returned, with the above attributes.
        let routePolylineHelper = RoutePolylineHelper(points: points, count: polyline.pointCount)
        routePolylineHelper.routeID = routeID
        
        return routePolylineHelper
    }
}

//due to built in Map limitations when routing I needed to create this view. Methods taken, and overriden from UIViewRepresentable
@MainActor
struct CustomMapView: UIViewRepresentable {
    var routes: [MKRoute] //changed to be an array, as it will handle multiple routes

    //I need to start using binding more
    @Binding var annotations: [MKPointAnnotation]
    @Binding var selectedAnnotation: MKPointAnnotation?
    @Binding var selectedRouteIndex: Int?
    var showOnlySelectedRoute: Bool = false

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
        
        //creating a custom renderer, update to it, so it works with selections
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            //main change is rather than use MKPolyline, I now use my helper class
            guard let routePolylineHelper = overlay as? RoutePolylineHelper else {
                return MKOverlayRenderer(overlay: overlay)
            }
            
            let polylineRenderer = MKPolylineRenderer(polyline: routePolylineHelper)
            
            if routePolylineHelper.isSelected {
                polylineRenderer.strokeColor = .blue
                polylineRenderer.lineWidth = 7
            }
            else {
                if parent.showOnlySelectedRoute{
                    polylineRenderer.alpha = 0
                }
                polylineRenderer.strokeColor = .gray
                polylineRenderer.lineWidth = 4
            }
            return polylineRenderer
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
        
        //changing this to allow 2 routes which are shown on the map
        for (index, route) in routes.enumerated() {
            let routePolylineHelper = RoutePolylineHelper.from(polyline: route.polyline, routeID: index)
            
            //default selection
            if let selectedIndex = selectedRouteIndex {
                routePolylineHelper.isSelected = (index % 2 == selectedIndex)
            } else {
                routePolylineHelper.isSelected = index % 2 == 0
            }
            
            mapView.addOverlay(routePolylineHelper)
        }
        
        //so this needs to be like this, otherwise it won't on real devices.................
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
        //added this so it feels more finished when route is mapped, changed to work more consistently with new setup
        if !routes.isEmpty {
            let mapRect = routes.map { $0.polyline.boundingMapRect }.reduce(MKMapRect.null) { $0.union($1) }
            mapView.setVisibleMapRect(mapRect, edgePadding:UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),animated: true)
        }
    }
}
