//
//  PlacesViewController.swift
//  checklist-for-trip
//
//  Created by Sena Uzun on 15.10.2022.
//

import UIKit
import Parse

class PlacesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {


    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    
    var selectedPlaceIdAtRow = ""
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))

        
        tableView.delegate = self
        tableView.dataSource = self

        getDataFromParse()
    }
    
    func getDataFromParse(){
       let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if objects != nil {
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)

                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenPlaceId = selectedPlaceIdAtRow
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceIdAtRow = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    @objc func logoutButtonClicked(){
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }else{
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
        
    }
    
    @objc func addButtonClicked(){
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    func makeAlert(titleInput : String , messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert , animated: true , completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                let query = PFQuery(className: "Places")
                query.whereKey("objectId", equalTo: placeIdArray[indexPath.row])
                query.findObjectsInBackground { (objects, error) in
                    if error != nil {
                        
                    }else{
                        if objects != nil{
                            if objects!.count > 0{
                                let choosenPlaceObject = objects![0]
                                choosenPlaceObject.deleteInBackground { (success, error)in
                                    if error != nil {
                                        print("Error")
                                    }else{
                                        self.placeNameArray.remove(at: indexPath.row)
                                        self.placeIdArray.remove(at: indexPath.row)
                                        self.tableView.reloadData()
                                        self.makeAlert(titleInput: "Success", messageInput: "Deletion successful!")
                                    }
                                }
                            }
                        }
                    }
                }
                    
            }
   
        }
}
