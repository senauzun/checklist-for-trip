//
//  PlaceModel.swift
//  checklist-for-trip
//
//  Created by Sena Uzun on 16.10.2022.
//

import Foundation
import UIKit

class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeCategory = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){
        
    }
}
