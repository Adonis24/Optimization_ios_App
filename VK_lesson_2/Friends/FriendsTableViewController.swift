//
//  FriendsTableViewController.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 07/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift


class FriendsTableViewController: UITableViewController {
    
    var names   = ["Брэдли Купер","Рассел Кроу","Ричард Гир","Леонардо ди Каприо"]
    var friends = ["Брэдли Купер":"Bredly","Рассел Кроу":"Russel","Ричард Гир":"Richard","Леонардо ди Каприо":"Leonardo"]
    var friendsFoto = ["Bredly":"Брэдли Купер","Bredly_1":"Брэдли Купер","Russel":"Рассел Кроу","Russel_1":"Рассел Кроу","Richard":"Ричард Гир","Richard_1":"Ричард Гир","Leonardo":"Леонардо ди Каприо","Leonardo_1":"Леонардо ди Каприо"]
    var characters: [String] = []//["Б","Р","Л"]
    var extFields = "first_name,last_name,photo_50,photo_100,photo_200,photo_400_orig,deactivated"
    var filtredCharacters: [String] = []
    static var realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    let searchController = UISearchController(searchResultsController: nil)
    var notificationToken: NotificationToken?
    var searchActive : Bool = false
    var filteredAllFriends : Results<User> = {
        return realm.objects(User.self)
    }()
    var vk_friends : Results<User> = {
        return realm.objects(User.self)
    }()
    var allFriendsCharacter = [""]
    //var vk_friends = [User]()
    var vkService = VKService()
    
    @IBAction func apiFriends(_ sender: Any) {
        getFriends()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        vkService.getFriends(){ [weak self] friend, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let friend = friend, let self = self {
                
                RealmProvider.save(items: friend.filter {$0.first_name != ""})
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: config) else { return }
        vk_friends = realm.objects(User.self)
        
    }
    
    // MARK: - Table view data source
    func getFriends()  {
        
        let url = "https://api.vk.com"
        let path = "/method/photos.getAll"
        let parameters: Parameters = [
            "access_token":Session.instance.token,
            "owner_id": 124396215,
            "photo_sizes": 1,
            "v":"5.85"
        ]
        Alamofire.request(url+path, method: .get, parameters:parameters)
            .responseJSON{response in
                guard let value = response.value else {return}
                print(value)
        }
    }
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Names"
        searchController.searchBar.isHidden = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    @IBAction func backAuthFriends(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Search
    
    //Search
    // * data sourse start
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isFiltering() {
            return filteringFirstLetter(in: filteredAllFriends).count
        } else {
            return filteringFirstLetter(in: vk_friends).count
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //        if isFiltering() {
        //            return filteredAllFriends.count
        //        } else {
        //            //return  names.filter {$0[$0.startIndex] == Character(characters[section]) }.count
        //            return vk_friends.filter({$0.first_name.first == Character(characters[section]) }).count
        //        }
        if isFiltering() {
            return filteringInSection(of: filteredAllFriends,in: section).count
        } else {
            return filteringInSection(of: vk_friends, in:section).count
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsTableViewCell
        var fUser:  Results<User>
        
        if isFiltering() {
            
            fUser = filteringInSection(of: filteredAllFriends, in: indexPath.section)
            
        } else {
            fUser = filteringInSection(of: vk_friends, in: indexPath.section)
            //fUser = vk_friends?.filter({$0.first_name.first == Character(self.characters[indexPath.section]) })[indexPath.row] ?? User()}
            
            
        }
        cell.configue(with: fUser[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "allFotoFriend", sender: self)
       
    }
    
    //* data source end
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isFiltering() { return 0} else {
            return CGFloat(25)
        }
    }
    //Titles section
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering() { return nil} else {
            return filteringFirstLetter(in: vk_friends)
        }
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isFiltering() {return nil} else {
            let viewHeader = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tableView.bounds.width, height: 25)))
            viewHeader.backgroundColor = tableView.backgroundColor
            viewHeader.alpha = 0.5
            //add label header start
            let headerL = UILabel(frame: CGRect(x: 20, y: 8, width: 50, height: 20))
            headerL.textAlignment = .center
            headerL.font = UIFont.italicSystemFont(ofSize: CGFloat(14))
            headerL.text = filteringFirstLetter(in: vk_friends)[section]//characters[section]
            viewHeader.addSubview(headerL)
            //add label header stop
            return viewHeader
        }
    }
    //transfer fotos
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //var listFriends = [User]()
        var fUser:  User
        var listFriends: Results<User>
        if segue.identifier == "allFotoFriend" {
            let fotoFriendsController  = segue.destination as! FriendFotos
            let myFriendsController = segue.source as! FriendsTableViewController
            //  Получаем индекс выделенной ячейки
            
            if let indexPath = myFriendsController.tableView.indexPathForSelectedRow {
                
                //let listFriends = myFriendsController.vk_friends.filter({$0.first_name.first == Character(self.characters[indexPath.section]) })
                if isFiltering() {
                    listFriends = filteringInSection(of: myFriendsController.filteredAllFriends, in: indexPath.section)
                } else {
                    listFriends = filteringInSection(of: myFriendsController.vk_friends, in: indexPath.section)
                }
                
                if listFriends.count>0 {
                    fUser = listFriends[indexPath.row]
                    fotoFriendsController.myFriendId = fUser.id
                }
            }
            
        }
    }
    
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        //filteredAllFriends = vk_friends?.filter({( user: User) -> Bool in return user.first_name.lowercased().contains(searchText.lowercased())
        // }
        //)
        filteredAllFriends = vk_friends.filter("first_name CONTAINS[cd] %@",searchText)
        self.tableView.reloadData()
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func pairTableAndRealm() {
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configuration) else {return }
        vk_friends = realm.objects(User.self)
        notificationToken = vk_friends.observe ({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }

            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let dels, let ins, let mods):
                tableView.applyChanges(deletions: dels, insertions: ins, updates: mods)
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }
    
}
extension FriendsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
extension FriendsTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}
extension FriendsTableViewController{
    func filteringFirstLetter (in friends: Results<User>) -> [String] {
        var friendsIndexTitles = [String]()
        for friend in friends {
            
            if let letter = friend.first_name.first {
                friendsIndexTitles.append(String(letter))
            } else {
                let letter = friend.first_name.first
                friendsIndexTitles.append(String(letter!))
            }
        }
        return Array(Set(friendsIndexTitles)).sorted()
    }
    func filteringInSection(of friends: Results<User>, in section:Int) -> Results<User>
    {
        let firstLetter = filteringFirstLetter(in: friends)[section]
        return friends.filter("first_name BEGINSWITH %@",firstLetter)
        
        
    }

}

