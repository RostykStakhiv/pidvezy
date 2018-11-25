

import UIKit
import GoogleMaps

class RouteMapVC: BaseVC {
    @IBOutlet weak var mapView: GMSMapView!
    
    let route: Route?
    
    //MARK: Init Methods
    init(route: Route) {
        self.route = route
        
        super.init()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        self.route = nil
        super.init(coder: aDecoder)
    }
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Route Info".localized
        self.setupMapView()
    }
    
    //MARK:Private Methods
    private func setupMapView() {
        guard let routePoints = route?.routePoints else { return }
        
        GooglePlacesManager.sharedManager.getGoogleDirectionForRoutePoints(routePoints) { (polyline) in
            polyline?.strokeWidth = 3
            polyline?.map = self.mapView
        }
        
        let bounds = GMSHelper.mapBoundsForCoordinates(routePoints)
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
        
        for addressModel in routePoints {
            var color: UIColor = UIColor.red
            
            if addressModel == routePoints.first {
                color = UIColor.green
            }
            
            if let pos = addressModel.location {
                let marker = GMSMarker(position: pos.coordinate)
                marker.title = addressModel.formattedAddress
                marker.icon = GMSMarker.markerImage(with: color)
                marker.map = self.mapView
            }
        }
    }
}
