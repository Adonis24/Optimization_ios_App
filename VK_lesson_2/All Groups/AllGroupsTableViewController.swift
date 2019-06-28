//
//  AllGroupsTableViewController.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

//import Firebase

extension AllGroupsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
class AllGroupsTableViewController: UITableViewController,UISearchBarDelegate {
 
    @IBAction func apiSearch(_ sender: Any) {
        if searchActive{
       searchGroup()
        }
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    /*
    var allGroups = ["Актеры","Композиторы","Автомобили","Спорт","Путешествие","Экстрим","Политика"]
    var allGroupsFoto = ["Актеры":"Actors","Композиторы":"Composers","Автомобили":"Сars","Спорт":"Sport","Путешествие":"Travel","Экстрим":"Extrim","Политика":"Polit"]
     */
 private var vkService = VKService()
    
    var vk_Groups = [Group]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredAllGroups = [Group]() 
    var searchActive : Bool = false
    var notificationToken: NotificationToken?
//    private var firebaseVK = [FirebaseVK]()
//    private let ref = Database.database().reference(withPath: "Allroups")
    
    override func viewDidLoad() {
        // observeFirebaseGroups()
        super.viewDidLoad()
    }
    
//    func observeFirebaseGroups() {
//        ref.observe(DataEventType.value) { snapshot in
//            var groups: [FirebaseVK] = []
//            
//            for child in snapshot.children {
//                guard let snapshot = child as? DataSnapshot,
//                    let group = FirebaseVK(snapshot: snapshot) else { continue }
//                
//                groups.append(group)
//            }
//            
//            self.firebaseVK = groups
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    func searchGroup()  {
        
        let url = "https://api.vk.com"
        let path = "/method/groups.search"
        let parameters: Parameters = [
            "access_token":Session.instance.token,
            "q":String(searchBar.text!),
            "v":"5.85"
        ]
        
        Alamofire.request(url+path, method: .get, parameters:parameters)
            .responseJSON{response in
                guard let value = response.value else {return}
                print(value)}
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText != "" {
        vkService.searchGroup(searchText: searchText){ [weak self] group, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let group = group, let self = self {
               
                   self.vk_Groups = group
                }
                DispatchQueue.main.async {
                    self?.filteredAllGroups = self!.vk_Groups.filter({( group: Group) -> Bool in return group.name.lowercased().contains(searchText.lowercased())})
                    self?.searchActive = true
                    self?.tableView.reloadData()
                    
                }
            }
        }

}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchActive{
            return filteredAllGroups.count
        }
        
        return vk_Groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "allGroupsCell", for: indexPath) as! AllGroupsCellTableViewCell

        var curGroup: Group
        
        if searchActive {
            
            curGroup = filteredAllGroups[indexPath.row]
            
        } else {
            
            curGroup = vk_Groups[indexPath.row]
           
        }
        cell.configue(with: curGroup)
       return cell
    }
 
    // MARK: - Private instance methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
        searchActive = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }


}
