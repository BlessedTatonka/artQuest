//
//  InfoTableViewController.swift
//  iosProject
//
//  Created by Patunique on 17.03.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import MapKit
import Parse

struct Rewiev {
    var title: String!
    var mark: Int!
    var name: String!
    var date: Date!
    var rewiev: String!
}

class InfoTableViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate var data : Array<Rewiev> = [
        Rewiev(title: "Выставка супер!", mark: 5, name: "Мария Ивакова", date: Date(), rewiev: "Выставка порадовала, мы с друзьями отлично поиграли. Наконец-то удалось првести время в музее интересно и увлекательно.Выставка порадовала, мы с друзьями отлично поиграли. Наконец-то удалось првести время в музее интересно и увлекательно.                                                              "),
        Rewiev(title: "Время потратил не зря", mark: 5, name: "Егор Кириллов", date: Date(), rewiev: "Все понравилось: вопросы интересные, иногда действительно долго думаешь и ищещшь ответы, но это даже хорошо, выставка запомнилась и, что самыое важное, получил кучу новых знаний. Такой формат квеста пришелся по душе, всем друзьям буду советовать! Единственное , что хочется исправить, так это попросить организаторов добавить такую... далее                                                              ")
        
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewievCell", for: indexPath) as! RewievCell
        cell.data = self.data[indexPath.item]
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RewievHeader", for: indexPath) as! RewievHeader
            headerView.initData()
            return headerView
        }
        fatalError()
    }
    
    
    var quest: QuestData!
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        spinner.isHidden = true
        super.viewDidLoad()
        
        initView()
        //initNavigationController()
        
//        mapView.delegate = self
//
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.startUpdatingLocation()
//
//        mapView.showsUserLocation = true
        
 
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
        locationLabel.text = quest.location
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(quest.location, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                
                self.currentPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
//                annotation.title = self.restaurant.name
//                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
        
        mapView.delegate = self
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
        
        mapView.showsUserLocation = true
        
    }
    
    @IBOutlet weak var startButton: FancyButton!
    var startClicked: Bool = false
    @IBAction func startNewQuestionsSession(_ sender: Any) {
        if (startClicked) {
            return
        }
        startClicked = true
        let delay = 1 // seconds
        spinner.isHidden = false
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            
            currentQuest = self.quest
            questionLogic.fillQuestionList(questId: self.quest.questId)
            
            if questionLogic.questionList.count < 1 {
                return
            }
            
            let vc = questionLogic.checkAndChange(storyboard: self.storyboard!)
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay) + .seconds(delay)) {
            self.startClicked = false
        }
        
    }
    
    
    func initView() {
        titleLabel.text = quest?.title
        themeLabel.text = quest?.theme
        descriptionTextView.text = quest?.description
        
        if let featuredImage = quest.image {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let topImageData = imageData {
                    self.topImageView.image = UIImage(data: topImageData)
                }
            })
        }
        
        priceLabel.text = String(quest!.price) + " рублей"
        ageLabel.text = quest?.age
        timeLabel.text = String(quest!.time) + " минут"
        difficultyLabel.text = quest?.difficulty
    }
    
    func initNavigationController() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .clear
        
    }
    
    @IBOutlet var mapView: MKMapView!
    
    //var currentRoute: MKRoute?
    
    @IBAction func showDirection(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: currentTransportType = MKDirectionsTransportType.automobile case 1: currentTransportType = MKDirectionsTransportType.walking default: break
        }
        segmentedControl.isHidden = false
        
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        let directionRequest = MKDirections.Request()
        // Set the source and destination of the route
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (routeResponse, routeError) -> Void in guard let routeResponse = routeResponse else {
            
            if let routeError = routeError { print("Error: \(routeError)")
            }
            return
            }
            let route = routeResponse.routes[0]
            //self.currentRoute = route
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController. // Pass the selected object to the new view controller.
        if segue.identifier == "showSteps" {
            let routeTableViewController = segue.destination.children[0] as! RouteTableViewController
//            if let steps = currentRoute?.steps {
//                routeTableViewController.routeSteps = steps
//            }
        }
        
    }
    
    
    let locationManager = CLLocationManager()
    
    //var restaurant:Restaurant!
    
    var currentPlacemark:CLPlacemark?
    
    @IBOutlet var segmentedControl:UISegmentedControl!
    
    var currentTransportType = MKDirectionsTransportType.automobile
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil }
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        if let currentPlacemarkCoordinate = currentPlacemark?.location?.coordinate { if currentPlacemarkCoordinate.latitude == annotation.coordinate.latitude &&
            currentPlacemarkCoordinate.longitude == annotation.coordinate.longitude { let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53,
                                                                                                                                        height: 53))
            //leftIconView.image = UIImage(named: restaurant.image)
            annotationView?.leftCalloutAccessoryView = leftIconView
            // Pin color customization
            if #available(iOS 9.0, *) { annotationView?.pinTintColor = UIColor.orange
            } } else {
            // Pin color customization
            if #available(iOS 9.0, *) { annotationView?.pinTintColor = UIColor.red
            } }
        }
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "showSteps", sender: view) }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor.blue : UIColor.orange
        
        renderer.lineWidth = 3.0
        return renderer
    }
}

class RewievHeader: UICollectionReusableView {
    @IBOutlet weak var overallMarkLabel: UILabel!
    @IBOutlet weak var overallCountLabel: UIButton!
    
    var user: User!
    
    func initData() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class RewievCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var markImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rewievLabel: UILabel!
    
    
    var data: Rewiev? {
        didSet {
            guard let data = data else { return }
            
            titleLabel.text = data.title
            nameLabel.text = data.name
            dateLabel.text = "\(data.date! as Date)"
            rewievLabel.text = data.rewiev
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

