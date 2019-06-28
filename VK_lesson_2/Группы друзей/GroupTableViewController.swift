//
//  GroupTableViewController.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 07/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import Kingfisher
//import Firebase
//import FirebaseDatabase


extension GroupTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
    }
}
//extension GroupTableViewController: UISearchBarDelegate {
//    // MARK: - UISearchBar Delegate
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filterContentForSearchText(searchBar.text!)
//    }
//}
class GroupTableViewController: UITableViewController,UISearchBarDelegate {
  
    var vkService = VKService()
    private var vk_Groups = [Group]()
    // private var vk_GroupsRealm = [Group]()
    private var vk_GroupsRealm: Results<Group>?
    let searchController = UISearchController(searchResultsController: nil)
    private var filteredAllGroups = [Group]()
    var searchActive : Bool = false
    var notificationToken: NotificationToken?
//    private var firebaseVK = [FirebaseVK]()
//    private let ref = Database.database().reference(withPath: "groups")
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедится, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let allGroupsController = segue.source as! AllGroupsTableViewController
            
            // Получаем индекс выделенной ячейки
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                // Получаем группу по индексу
                let group = allGroupsController.vk_Groups[indexPath.row]
                // Добавляем группу в список
                if !vk_Groups.contains{$0.id == group.id} {
                    vk_Groups.append(group)
                 // FirebaseVK.addGroup(user: String(Session.instance.userId), group: group)
                                                                        
                    
                    // Обновляем таблицу
                    tableView.reloadData()
                }
            }
            
        }
        
    }
    
//    let alertVC = UIAlertController(title: "Enter a city name please", message: nil, preferredStyle: .alert)
//
//    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
//        guard let textField = alertVC.textFields?.first,
//            let cityname = textField.text else { return }
//
//        // 1
//        let city = FirebaseCity(name: cityname,
//                                zipcode: Int.random(in: 100000...999999))
//        // 2
//        let cityRef = self.ref.child(cityname.lowercased())
//
//        cityRef.setValue(city.toAnyObject())
//    }
//
//    let cancelAction = UIAlertAction(title: "Cancel",
//                                     style: .cancel)
//
//    alertVC.addTextField()
//
//    alertVC.addAction(saveAction)
//    alertVC.addAction(cancelAction)
//
//    present(alertVC, animated: true, completion: nil)
    
    /* статические данные для теста
    var nameGroups   = ["Актеры","Композиторы","Автомобили"]
    var groups = ["Актеры":"Actors","Композиторы":"Composers","Автомобили":"Сars"]
    */

    
    @IBAction func apiGroups(_ sender: Any) {
        getGroups()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        //вилл аппир нельзя добавлять добавление групп не будет работать
        vkService.getGroup(){ [weak self] group, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let group = group, let self = self {
                // self.vk_Groups = group
                RealmProvider.save(items:group)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: config)
        vk_GroupsRealm = realm.objects(Group.self)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
        searchActive = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searchActive = false
        } else {
            searchActive = true
            //filteredAllGroups = vk_Groups.filter({( group: Group) -> Bool in return group.name.lowercased().contains(searchText.lowercased())})
            //vk_GroupsRealm
            guard let groups = vk_GroupsRealm else { return }
            filteredAllGroups = groups.filter({( group: Group) -> Bool in return group.name.lowercased().contains(searchText.lowercased())})
            //vk_GroupsRealm
            self.tableView.reloadData()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    /* Работа с БД Реалм начало */
    
    
    func readGroupDb()  {
        //read Db
        
        // }
    }
    /* Работа с БД Реалм окончание */
    
    @IBAction func backAuthGroup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func getGroups(){
        let url = "https://api.vk.com"
        let path = "/method/groups.get"
        let parameters: Parameters = [
            "access_token":Session.instance.token,
            "extended":"1",
            "count":"100",
            "v":"5.85"
        ]
        
        Alamofire.request(url+path, method: .get, parameters:parameters)
            .responseJSON{response in
                guard let value = response.value else {return}
                print(value)}
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive{
            return filteredAllGroups.count
        } else {
            //return vk_Groups.count
            return vk_GroupsRealm?.count ?? 0
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as! GroupTableViewCell
        if searchActive {
            cell.configue(with: filteredAllGroups[indexPath.row])
        } else {
            let group = vk_GroupsRealm?[indexPath.row]
            // cell.configue(with: vk_Groups[indexPath.row])
            cell.configue(with: group ?? Group())
        }
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            // Delete the row from the data source
            //            vk_Groups.remove(at: indexPath.row)
            //            //vk_GroupsRealm?.remove(at: indexPath.row)
            //            tableView.deleteRows(at: [indexPath], with: .fade)
            let gr = vk_GroupsRealm?[indexPath.row]
            vkService.deleteGroups(for: gr!.id){ [weak self] groups, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else if let groups = groups, let self = self {
                    
                    RealmProvider.save(items: groups)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            RealmProvider.delete([gr!])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func pairTableAndRealm() {
        
        vk_GroupsRealm =  RealmProvider.get(Group.self)
        notificationToken = vk_GroupsRealm?.observe { [weak self] changes in
            guard let self = self else { return }
            // guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                self.tableView.reloadData()
                
            case .update(_, let dels, let ins, let mods):
                self.tableView.applyChanges(deletions: dels, insertions: ins, updates: mods)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
