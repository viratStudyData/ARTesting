//
//  ViewController.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import UIKit
import SceneKit
import MapKit
import ARCL

//https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=30.712233586265437,76.707238582965644&radius=5000&keyword=starbucks&key=AIzaSyCh8CplRAuiiOAVExK4At1Qgbi7fBHaLfs

//https://maps.googleapis.com/maps/api/place/photo?photoreference=(GooglePhotoRefference)&key=(GoogleKey)&sensor=false&maxwidth=80


@available(iOS 11.0, *)
class ViewController: UIViewController {
    let sceneLocationView = SceneLocationView()

    let mapView = MKMapView()
    let mapView1 = MKMapView()
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    
    var updateUserLocationTimer: Timer?

    var flag = true
    ///Whether to show a map view
    ///The initial value is respected
    var showMapView: Bool = false
    
    var centerMapOnUserLocation: Bool = true

    ///Whether to display some debugging data
    ///This currently displays the coordinate of the best location estimate
    ///The initial value is respected
    var displayDebugging = false

    var infoLabel = UILabel()

    var updateInfoLabelTimer: Timer?

    var adjustNorthByTappingSidesOfScreen = false
    
    var arrNearByLocations: [[String: AnyObject]] = [[String: AnyObject]]()

    var btnPlus:UIButton = UIButton()
    var btnLocation:UIButton = UIButton()
    var btnDirection:UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.textAlignment = .left
        infoLabel.textColor = UIColor.white
        infoLabel.numberOfLines = 0
//        sceneLocationView.addSubview(infoLabel)

        updateInfoLabelTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(ViewController.updateInfoLabel),
            userInfo: nil,
            repeats: true)

        // Set to true to display an arrow which points north.
        //Checkout the comments in the property description and on the readme on this.
//        sceneLocationView.orientToTrueNorth = false

//        sceneLocationView.locationEstimateMethod = .coreLocationDataOnly
//        sceneLocationView.showAxesNode = true
        sceneLocationView.locationDelegate = self

        if displayDebugging {
            sceneLocationView.showFeaturePoints = true
        }

//        buildDemoData().forEach { sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0) }

        view.addSubview(sceneLocationView)

        if showMapView {
            mapView.delegate = self
            mapView.showsUserLocation = true
            mapView.alpha = 0.8
            view.addSubview(mapView)

            updateUserLocationTimer = Timer.scheduledTimer(
                timeInterval: 0.5,
                target: self,
                selector: #selector(ViewController.updateUserLocation),
                userInfo: nil,
                repeats: true)
        }
        
        let imgBtnPlus = UIImage(named: "ic_plus")
        let imgBtnDirection = UIImage(named: "ic_direction")
        let imgBtnLocation = UIImage(named: "ic_location")
        
        let viewSize = self.view.frame.size
        
        btnLocation.frame = CGRect(x: viewSize.width - (imgBtnLocation?.size.width)! - 20, y: viewSize.height - (imgBtnLocation?.size.height)! - 50, width: (imgBtnLocation?.size.width)!, height: (imgBtnLocation?.size.width)!)
        btnLocation.setImage(imgBtnLocation, for: .normal)
        btnLocation.addTarget(self, action: #selector(self.btnLocationAction), for: .touchUpInside)
        btnLocation.isHidden = true
        btnLocation.isSelected = false
        self.view.addSubview(btnLocation)
        
        btnDirection.frame = CGRect(x: viewSize.width - (imgBtnDirection?.size.width)! - 20, y: viewSize.height - (imgBtnDirection?.size.height)! - 50, width: (imgBtnDirection?.size.width)!, height: (imgBtnDirection?.size.width)!)
        btnDirection.setImage(imgBtnDirection, for: .normal)
        btnDirection.addTarget(self, action: #selector(self.btnDirectionAction), for: .touchUpInside)
        btnDirection.isHidden = true
        self.view.addSubview(btnDirection)
        
        btnPlus.frame = CGRect(x: viewSize.width - (imgBtnPlus?.size.width)! - 20, y: viewSize.height - (imgBtnPlus?.size.height)! - 50, width: (imgBtnPlus?.size.width)!, height: (imgBtnPlus?.size.width)!)
        btnPlus.setImage(imgBtnPlus, for: .normal)
        btnPlus.addTarget(self, action: #selector(self.btnPlusAction), for: .touchUpInside)
        btnPlus.isSelected = false
        self.view.addSubview(btnPlus)
        
        btnLocation.center = btnPlus.center
        btnDirection.center = btnPlus.center
    }
    
    @objc func btnPlusAction() {
        if btnPlus.isSelected {
            btnPlus.isSelected = false
            btnPlus.setImage(UIImage(named: "ic_plus"), for: .normal)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.btnLocation.frame.origin.y += 125
                self.btnDirection.frame.origin.y += 65
            }, completion: { finish in
                self.btnLocation.isHidden = true
                self.btnDirection.isHidden = true
            })
        }else {
            btnPlus.isSelected = true
            btnLocation.isHidden = false
            btnDirection.isHidden = false
        
            btnPlus.setImage(UIImage(named: "ic_cross"), for: .normal)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.btnLocation.frame.origin.y -= 125
                self.btnDirection.frame.origin.y -= 65
            })
        }
    }
    
    @objc func btnLocationAction() {
        if btnLocation.isSelected {
            btnLocation.isSelected = false
            UIView.animate(withDuration: 0.5, animations: {
                self.mapView1.frame.origin.y += 180
            }, completion:{finish in
                self.mapView1.removeFromSuperview()
            })
            
        }else {
            btnLocation.isSelected = true
            
            mapView1.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 180)
            mapView1.delegate = self
            mapView1.showsUserLocation = true
            for dict in arrNearByLocations {
                let lat:CLLocationDegrees = Double(truncating: dict["lat"] as! NSNumber)
                let long:CLLocationDegrees = Double(truncating: dict["long"] as! NSNumber)
                let annotation1 = MKPointAnnotation()
                annotation1.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let strTitle: String = dict["name"] as! String
                annotation1.title = strTitle
                mapView1.addAnnotation(annotation1)
            }
            self.view.addSubview(mapView1)
            UIView.animate(withDuration: 0.5, animations: {
                self.mapView1.frame.origin.y -= 180
            })
        }
    }
    
    @objc func btnDirectionAction() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("run")
        sceneLocationView.run()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("pause")
        // Pause the view's session
        sceneLocationView.pause()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        sceneLocationView.frame = view.bounds

        infoLabel.frame = CGRect(x: 6, y: 0, width: self.view.frame.size.width - 12, height: 14 * 4)

        if showMapView {
            infoLabel.frame.origin.y = (self.view.frame.size.height / 2) - infoLabel.frame.size.height
        } else {
            infoLabel.frame.origin.y = self.view.frame.size.height - infoLabel.frame.size.height
        }

        mapView.frame = CGRect(
            x: 0,
            y: self.view.frame.size.height / 2,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height / 2)
    }

    //MARK: Update User Location
    @objc func updateUserLocation() {
        guard let currentLocation = sceneLocationView.currentLocation() else {
            return
        }

        DispatchQueue.main.async {
            if let bestEstimate = self.sceneLocationView.bestLocationEstimate(),
                let position = self.sceneLocationView.currentScenePosition() {
                print("")
                print("Fetch current location")
                print("best location estimate, position: \(bestEstimate.position), location: \(bestEstimate.location.coordinate), accuracy: \(bestEstimate.location.horizontalAccuracy), date: \(bestEstimate.location.timestamp)")
                print("current position: \(position)")

                let translation = bestEstimate.translatedLocation(to: position)

                print("translation: \(translation)")
                print("translated location: \(currentLocation)")
                print("")
                
            }

            if self.userAnnotation == nil {
                self.userAnnotation = MKPointAnnotation()
                self.mapView.addAnnotation(self.userAnnotation!)
                
            }

            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.userAnnotation?.coordinate = currentLocation.coordinate
            }, completion: nil)

            if self.centerMapOnUserLocation {
                UIView.animate(withDuration: 0.45, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
                }, completion: { _ in
                    self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                })
            }

            if self.displayDebugging {
                let bestLocationEstimate = self.sceneLocationView.bestLocationEstimate()

                if bestLocationEstimate != nil {
                    if self.locationEstimateAnnotation == nil {
                        self.locationEstimateAnnotation = MKPointAnnotation()
                        self.mapView.addAnnotation(self.locationEstimateAnnotation!)
                    }

                    self.locationEstimateAnnotation!.coordinate = bestLocationEstimate!.location.coordinate
                } else {
                    if self.locationEstimateAnnotation != nil {
                        self.mapView.removeAnnotation(self.locationEstimateAnnotation!)
                        self.locationEstimateAnnotation = nil
                    }
                }
            }
        }
        
    }

    @objc func updateInfoLabel() {
        if let position = sceneLocationView.currentScenePosition() {
            infoLabel.text = "x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))\n"
        }

        if let eulerAngles = sceneLocationView.currentEulerAngles() {
            infoLabel.text!.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))\n")
        }

        if let heading = sceneLocationView.locationManager.heading,
            let accuracy = sceneLocationView.locationManager.headingAccuracy {
            infoLabel.text!.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º\n")
        }

        let date = Date()
        let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)

        if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
            infoLabel.text!.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
        }
    }

    //MARK: Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
/*
        guard
            let touch = touches.first,
            let touchView = touch.view
        else {
            return
        }

        if mapView == touchView || mapView.recursiveSubviews().contains(touchView) {
            centerMapOnUserLocation = false
        } else {
            let location = touch.location(in: self.view)

            if location.x <= 40 && adjustNorthByTappingSidesOfScreen {
                print("left side of the screen")
                sceneLocationView.moveSceneHeadingAntiClockwise()
            } else if location.x >= view.frame.size.width - 40 && adjustNorthByTappingSidesOfScreen {
                print("right side of the screen")
                sceneLocationView.moveSceneHeadingClockwise()
            } else {
                let image1 = UIImage(named: "pin")!
                let annotationNode = LocationAnnotationNode(location: nil, image: image1)
                annotationNode.scaleRelativeToDistance = true
                sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
            }
        }*/
    }
 

}

// MARK: - MKMapViewDelegate
@available(iOS 11.0, *)
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        guard let pointAnnotation = annotation as? MKPointAnnotation else {
            return nil
        }

        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        marker.displayPriority = .required

        if pointAnnotation == self.userAnnotation {
            marker.glyphImage = UIImage(named: "user")
        } else {
            marker.markerTintColor = UIColor(hue: 0.267, saturation: 0.67, brightness: 0.77, alpha: 1.0)
            marker.glyphImage = UIImage(named: "compass")
        }

        return marker
    }
    
}

// MARK: - SceneLocationViewDelegate
@available(iOS 11.0, *)
extension ViewController: SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
        if flag {
            
            self.getNearByLocation(cordinates: location.coordinate)
        }
        flag = false
    }

    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }

    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }

    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {

    }

    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {

    }
    
    //MARK: Get Location
    func getNearByLocation(cordinates: CLLocationCoordinate2D) {
        let strUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(cordinates.latitude),\(cordinates.longitude)&radius=1000&keyword=Technology&key=AIzaSyCh8CplRAuiiOAVExK4At1Qgbi7fBHaLfs"
        APIHandler.getJSON(withUrl: strUrl, withParameters: nil, success: {(response) in
            print(response)
            if let arr = response["results"] as? [[String: AnyObject]] {
                for dict in arr {
                    let tempDict = ["lat":((dict["geometry"] as! [String: AnyObject] )["location"] as! [String: AnyObject])["lat"]!, "long":((dict["geometry"] as! [String: AnyObject] )["location"] as! [String: AnyObject])["lng"]!, "name":dict["name"]!, "icon":dict["icon"]!] as [String : AnyObject]
                    self.arrNearByLocations.append(tempDict)
                }
                self.addNotation().forEach { self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0) }
                
            }
        }, failure: {(error) in
            print(error)
        })
    }
    
    func addNotation() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        for dict in arrNearByLocations {
            
            let url = URL(string:dict["icon"] as! String)
            let data = try? Data(contentsOf: url!)
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 4
            
            let imgVw = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
            imgVw.layer.cornerRadius = 20
            imgVw.image = (data == nil) ? UIImage(named: "locationIcon") : UIImage(data: data!)
            view.addSubview(imgVw)
            
            let imgVwOffer = UIImageView(frame: CGRect(x: 55, y: 30, width: 80, height: 20))
            imgVwOffer.layer.cornerRadius = 20
            imgVwOffer.image = UIImage(named: "offer")
            view.addSubview(imgVwOffer)
            
            let vwLine = UIView(frame: CGRect(x: 50, y: 0, width: 2, height: 60))
            vwLine.backgroundColor = UIColor.lightGray
            view.addSubview(vwLine)
            
            let lbl = UILabel(frame: CGRect(x: 57, y: 5, width: view.frame.size.width - 62, height: 20))
            lbl.font = UIFont.systemFont(ofSize: view.frame.size.height/8)
            lbl.text = dict["name"] as? String ?? ""
            lbl.textColor = UIColor.darkGray
            view.addSubview(lbl)
            
            
            UIGraphicsBeginImageContext(view.frame.size)
            view.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            let lat:CLLocationDegrees = Double(truncating: dict["lat"] as! NSNumber)
            let long:CLLocationDegrees = Double(truncating: dict["long"] as! NSNumber)
            
            let annotationNode = buildNodeWithImage(latitude: lat, longitude: long, altitude: 236, image: image!)
            nodes.append(annotationNode)
        }
        return nodes
    }
}

// MARK: - Data Helpers
@available(iOS 11.0, *)
private extension ViewController {
    func buildDemoData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []

        // TODO: add a few more demo points of interest.
        // TODO: use more varied imagery.

        let spaceNeedle = buildNode(latitude: 47.6205, longitude: -122.3493, altitude: 225, imageName: "pin")
        nodes.append(spaceNeedle)

        let empireStateBuilding = buildNode(latitude: 40.7484, longitude: -73.9857, altitude: 14.3, imageName: "pin")
        nodes.append(empireStateBuilding)

        let canaryWharf = buildNode(latitude: 51.504607, longitude: -0.019592, altitude: 236, imageName: "pin")
        nodes.append(canaryWharf)

        return nodes
    }

    func buildNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let image = UIImage(named: imageName)!
        return LocationAnnotationNode(location: location, image: image)
    }
    func buildNodeWithImage(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, image: UIImage) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
    
        return LocationAnnotationNode(location: location, image: image)
    }
   
}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews

        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }

        return recursiveSubviews
    }
}
