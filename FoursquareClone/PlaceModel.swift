//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Italo Stuardo on 18/4/23.
//

import Foundation
import UIKit
import Parse

class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var chosenLatitude = ""
    var chosenLongitude = ""
    var image: PFFileObject? = nil
    
    private init() { }
}
