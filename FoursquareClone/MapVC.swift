//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Italo Stuardo on 18/4/23.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    private let reuseIdentifier = "PinAnnotationView"
    var annotationView: MKMarkerAnnotationView?
    var locationManager = CLLocationManager()
    let place = PlaceModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        navigationItem.setRightBarButton(saveButton, animated: true)
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
        tapGesture.minimumPressDuration = 3.0
        mapView.addGestureRecognizer(tapGesture)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let center = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func addPin(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            place.chosenLatitude = String(coordinate.latitude)
            place.chosenLongitude = String(coordinate.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.canShowCallout = true

        return annotationView
    }
    
    @objc func save() {
        let object = PFObject(className: "Places")
        
        object["name"] = place.placeName
        object["type"] = place.placeType
        object["atmosphere"] = place.placeAtmosphere
        object["latitude"] = place.chosenLatitude
        object["longitude"] = place.chosenLongitude
        
        if let imageData = place.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground { success, error in
            if error != nil {
                AlertModel.shared.alert(title: "Error", message: error?.localizedDescription ?? "Error...", view: self)
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlaceVC", sender: nil)
            }
        }
    }
}
