//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Italo Stuardo on 18/4/23.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var atmosphereLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let place = PlaceModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        let latitude: CLLocationDegrees = Double(place.chosenLatitude)!
        let longitude: CLLocationDegrees = Double(place.chosenLongitude)!
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = place.placeName
        annotation.subtitle = place.placeType
        mapView.addAnnotation(annotation)
        
        loadDetails()
    }
    
    func loadDetails() {
        nameLabel.text = place.placeName
        typeLabel.text = place.placeType
        atmosphereLabel.text = place.placeAtmosphere
        
        place.image?.getDataInBackground(block: { data, error in
            if error == nil {
                if let imageData = data {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseIdentifier = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let latitud = CLLocationDegrees(place.chosenLatitude) {
            if let longitude = CLLocationDegrees(place.chosenLongitude) {
                let requestLocation = CLLocation(latitude: latitud, longitude: longitude)
                CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                    if let placemark = placemarks {
                        if placemark.count > 0 {
                            let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                            let mapItem = MKMapItem(placemark: mkPlaceMark)
                            mapItem.name = self.place.placeName
                            
                            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                            mapItem.openInMaps(launchOptions: launchOptions)
                        }
                    }
                }
            }
        }
    }
}
