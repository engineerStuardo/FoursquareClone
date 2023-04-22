//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Italo Stuardo on 17/4/23.
//

import UIKit
import Parse

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var idArray = [String]()
    var typeArray = [String]()
    var atmosphereArray = [String]()
    var latitudeArray = [String]()
    var longitudeArray = [String]()
    var imageArray = [PFFileObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlace))
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.setRightBarButton(add, animated: true)
        navigationItem.setLeftBarButton(logout, animated: true)
        
        getData()
    }
    
    func getData() {
        PFQuery(className: "Places").findObjectsInBackground { objects, error in
            if error != nil {
                AlertModel.shared.alert(title: "Error", message: error?.localizedDescription ?? "Error", view: self)
            } else {
                self.nameArray.removeAll()
                self.idArray.removeAll()
                self.typeArray.removeAll()
                self.atmosphereArray.removeAll()
                self.latitudeArray.removeAll()
                self.longitudeArray.removeAll()
                
                if objects != nil {
                    for obj in objects! {
                        if let name = obj.object(forKey: "name") as? String {
                            self.nameArray.append(name)
                        }
                        
                        if let id = obj.objectId {
                            self.idArray.append(id)
                        }
                        
                        if let type = obj.object(forKey: "type") as? String {
                            self.typeArray.append(type)
                        }
                        
                        if let atmosphere = obj.object(forKey: "atmosphere") as? String {
                            self.atmosphereArray.append(atmosphere)
                        }
                        
                        if let latitude = obj.object(forKey: "latitude") as? String {
                            self.latitudeArray.append(latitude)
                        }
                        
                        if let longitude = obj.object(forKey: "longitude") as? String {
                            self.longitudeArray.append(longitude)
                        }
                        
                        if let imageData = obj.object(forKey: "image") as? PFFileObject {
                            self.imageArray.append(imageData)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addPlace() {
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    @objc func logout() {
        PFUser.logOutInBackground { error in
            if error != nil {
                AlertModel.shared.alert(title: "Error", message: error?.localizedDescription ?? "Error when logout", view: self)
            } else {
                self.performSegue(withIdentifier: "toLogInVC", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = nameArray[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var place = PlaceModel.sharedInstance
        place.placeName = nameArray[indexPath.row]
        place.placeType = typeArray[indexPath.row]
        place.placeAtmosphere = atmosphereArray[indexPath.row]
        place.chosenLatitude = latitudeArray[indexPath.row]
        place.chosenLongitude = longitudeArray[indexPath.row]
        place.image = imageArray[indexPath.row]
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }

}
