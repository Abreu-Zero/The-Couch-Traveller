//
//  MapViewController.swift
//  TheCouchTraveller
//
//  Created by Henrique Abreu on 03/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressRec: UILongPressGestureRecognizer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var annotations = [MKPointAnnotation]()
    var dataController: DataController?
    var locations: [Location] = []
    var toPass: Location?
    var longitude: Double = 0
    var latitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMap()
    
    }


// MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        let reuseId = "pin"
    
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
    
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let lon = view.annotation?.coordinate.longitude
        let lat = view.annotation?.coordinate.latitude
        for l in locations{
            if l.longitude == lon && l.latitude == lat{
                self.toPass = l
            }
        }
        performSegue(withIdentifier: "showPhotos", sender: view)

    }
    
    
    //MARK: Map Funcs
    // fetches request from datamodel and loads the mapview
    func loadMap(){
        
        let fetchRequest : NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescription]

        guard let result = try? dataController?.viewContext.fetch(fetchRequest) else{return}
        locations = result
        if locations.count > 0{
            for location in locations{
                let geoPos = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let annotation = IndexedAnnotation(coordinate: geoPos)
                let loc: CLLocation = CLLocation(latitude:geoPos.latitude, longitude: geoPos.longitude)
                CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) in
                    guard let placemark = placemarks?.first else { return }
                    annotation.title = placemark.name ?? "Not Known"
                    annotation.subtitle = placemark.country
                    annotation.coordinate = loc.coordinate
                    annotation.index = self.locations.firstIndex(of: location)
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(annotation)

                    }
                }
            }
            
        }
        
    }
    
    //MARK: Touch Funcs
    
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            activityIndicator.startAnimating()
        } else if sender.state == .ended {
            let coord = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            saveGeoCoordination(from: coord)
            activityIndicator.stopAnimating()

        }
    }
    
    //convert and save the longPress into coordinates
    func saveGeoCoordination(from coordinate: CLLocationCoordinate2D) {
        let geoPos = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let savedGeo = Location(context: dataController!.viewContext)
        savedGeo.latitude = geoPos.coordinate.latitude
        savedGeo.longitude = geoPos.coordinate.longitude
        savedGeo.creationDate = Date()
        try? dataController!.viewContext.save()
        
        let annotation = IndexedAnnotation(coordinate: coordinate)
        CLGeocoder().reverseGeocodeLocation(geoPos) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            annotation.title = placemark.name ?? "Not Known"
            annotation.subtitle = placemark.country
            annotation.index = self.locations.firstIndex(of: savedGeo)
            annotation.coordinate = coordinate
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)

            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PhotoAlbumViewController
        let location = sender as! MKAnnotationView
        destination.latitude = location.annotation?.coordinate.latitude
        destination.longitude = location.annotation?.coordinate.longitude
        destination.dataController = dataController
        destination.location = toPass

        
        //TODO: inject location so PhotoAlbumViewController can download the pictures!!!
    }
}



