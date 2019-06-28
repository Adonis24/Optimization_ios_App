//
//  FriendFotos.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import RealmSwift

class FriendFotos: UIViewController {
    
    var vkService = VKService()
    var allFotoOneFriend = [Photo]()
    //var allFotoOneFriend: Results<Photo>?
    var listPhoto = [Photo]()
    var myFriendId: Int = 0
    var photoId: Int = 0
    static var realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    lazy var photosFriends: Results<Photo>? = try! RealmProvider.get(Photo.self)?.filter("ANY photosForUser.id == %@ AND url != %e", photoId,"")
    var notificationToken: NotificationToken?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    @IBAction func apiFotos(_ sender: UIBarButtonItem) {
//        getFotos(owner_id: allFotoOneFriend?[0].id)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        pairCollectionAndRealm()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //  self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listPhoto = [Photo]()
        vkService.getFoto(owner_id: myFriendId, completion: { [weak self] photos,error in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let photos = photos, let self = self {
                
                //self.allFotoOneFriend = photos
               
                
                RealmProvider.save(items: photos)
                RealmProvider.savePhotoForUser(photos, id: self.myFriendId)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
            
        )
     
        photosFriends = RealmProvider.get(Photo.self)?.filter("ANY photosForUser.id == %@ AND url != %e", self.myFriendId,"")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    func getFotos(owner_id: Int)  {
        
        let url = "https://api.vk.com"
        let path = "/method/photos.getAll"
        let parameters: Parameters = [
            "access_token":Session.instance.token,
            "owner_id": owner_id,
            "photo_sizes": 1,
            "v":"5.85"
        ]
        
        Alamofire.request(url+path, method: .get, parameters:parameters)
            .responseJSON{response in
                guard let value = response.value else {return}
                print(value)
        }
    }
    
}
extension FriendFotos: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFriends?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        var url_photo = ""
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendFotos", for: indexPath) as! FriendFotoCell
        let photo = self.photosFriends?[indexPath.row]
        url_photo = photo?.url ?? ""
        cell.configue(with: url_photo)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func pairCollectionAndRealm() {
        
       
        
        notificationToken = photosFriends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let dels, let ins, let mods):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: ins.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: dels.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: mods.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)

            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}



