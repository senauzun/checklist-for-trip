//
//  VisitedPlacesViewController.swift
//  checklist-for-trip
//
//  Created by Sena Uzun on 18.10.2022.
//

import UIKit
import Parse

class VisitedPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var placeNameArray = [String]()
    @IBOutlet weak var visitedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        visitedTableView.delegate = self
        visitedTableView.dataSource = self
        
        addDataforVisited()
    }
    
    func addDataforVisited(){
        let query = PFQuery(className: "VisitedPlaces")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
            }
            else{
                if objects != nil {
                    self.placeNameArray.removeAll(keepingCapacity: false)

                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                                self.placeNameArray.append(placeName)
                            
                        }
                    }
                }
                self.visitedTableView.reloadData()

            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
}
