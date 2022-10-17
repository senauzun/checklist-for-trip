//
//  DetailsViewController.swift
//  checklist-for-trip
//
//  Created by Sena Uzun on 16.10.2022.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController , MKMapViewDelegate {

    
    @IBOutlet weak var placenameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParseForDetails()
        mapView.delegate = self

    }
    
    func getDataFromParseForDetails(){
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
            }
            else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        
                        if let detailsPlaceName = chosenPlaceObject.object(forKey: "name") as? String {
                            self.placenameLabel.text = detailsPlaceName
                        }
                        if let detailsPlaceCategory = chosenPlaceObject.object(forKey: "category") as? String {
                            self.categoryLabel.text = detailsPlaceCategory
                        }
                        
                        //COORDINATES
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.chosenLatitude = placeLatitudeDouble
                            }
                            
                        }
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.chosenLongitude = placeLongitudeDouble
                            }
                            
                        }
                        
                        //IMAGE
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.imageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }

                        
                        //MAPS
                        
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.mapView.setRegion(region, animated: true)
                        
                        //Pin
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.placenameLabel.text!
                        annotation.subtitle = self.categoryLabel.text!
                        self.mapView.addAnnotation(annotation)
                        
                    }
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // if annotation is user loc , return nil
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        
        var pinView =  mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.placenameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions : launchOptions)
                    }
                }
            }
        }
    }

}
