//
//  NewsListViewController.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 14/04/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import Kingfisher
class NewsListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var headers = [["new1":"Остров Панган – наш самый любимый остров в Таиланде и одно из лучших мест в Юго-Восточной Азии"],["new2":"Самуй – второй по величине остров Таиланда, расположенный в Сиамском заливе у восточного побережья перешейка Кра. Он пользуется огромной популярностью у туристов благодаря окаймленным пальмами пляжам, кокосовым рощам, густым горным тропическим лесам, роскошным курортам и шикарным спа-центрам. "]]
    var news = [["new1":"pangan"],["new2":"samui"]]
    var vkService = VKService()
    var newsService = NewsService()
    static var realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    var vk_news : Results<News>? = {realm.objects(News.self)}()
    var notificationToken: NotificationToken?
    var headersSection = ["Автор обзора Паган","Автор обзора Самуй"]
    
   
     func numberOfSections(in tableView: UITableView) -> Int {
        
        return vk_news!.count//headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsBodyCell", for: indexPath) as! NewsTableBodyCell
            cell.NewsBody.text =   vk_news?[indexPath.section].text//Array(headers[indexPath.section])[0].value
            return cell
        }
        else if indexPath.item == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as! NewsTablePhotoCell
            if (vk_news?[indexPath.section].photo.isEmpty)! {
               cell.newsPhoto.image =  UIImage(named: Array(news[1])[0].value)
            } else {
            if let photo = vk_news?[indexPath.section].photo[0]
            {
            let urlPhoto = URL(string: photo.url)
                cell.newsPhoto.kf.setImage(with: urlPhoto)
            }
            else {
                cell.newsPhoto.image =  UIImage(named: Array(news[1])[0].value)// заглушка
                }
                
            }

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsActionsCell", for: indexPath) as! NewsTableActionsCell
            cell.NewsCommentView.commentLabel.text = "\(String(describing: vk_news![indexPath.section].comments_count))"
            cell.NewsEyesView.eyesLabel.text = "\(String(describing: vk_news![indexPath.section].views_count))"
            cell.NewsLikeView.likeLabel.text = "\(String(describing: vk_news![indexPath.section].likes_count))"
            cell.NewsShareView.shareLabel.text = "\(String(describing: vk_news![indexPath.section].reposts_count))"
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
     return 48
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //  Инициализация вью для отображения аватара и представления автора новости
        let viewHeader = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tableView.frame.size.width, height: 40)))
        viewHeader.backgroundColor = tableView.backgroundColor
        viewHeader.alpha = 0.5
        //add logo header start
        let headerAvatar = UIImageView()
        headerAvatar.frame = CGRect(x: 0, y: 8, width: 50, height: 40)
        //начало получение фото-аватар группы или пользователя автора новости
        let urlAvatar = URL(string: vk_news![section].icon_image)
        headerAvatar.kf.setImage(with: urlAvatar)
        headerAvatar.imgViewCorners()
        viewHeader.addSubview(headerAvatar)
        //add label header start
        let headerL = UILabel(frame: CGRect(x: 60, y: 8, width: 50, height: 40))
        headerL.textAlignment = .left
        headerL.font = UIFont.boldSystemFont(ofSize: CGFloat(19))
        headerL.text = vk_news?[section].name_lable
         // if (section>1) { headerL.text = vk_news?[1].text} else { headerL.text  = vk_news?[section].text}//headersSection[section]
        viewHeader.addSubview(headerL)
        //    добавляем привязки к правому углу
        headerL.snp.makeConstraints{(make) -> Void in
            make.right.equalTo(viewHeader)
            headerL.snp.makeConstraints{ (make) -> Void in
                make.left.equalTo(headerAvatar.snp.right).offset(10)
            }
        }
        //add label header stop
       return viewHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        pairTableAndRealm()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // tableView.register(UINib(nibName: "NewsTableHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "NewsHeaderCell")
        tableView.register(UINib(nibName: "NewsTableBodyCell", bundle: nil), forCellReuseIdentifier: "NewsBodyCell")
        tableView.register(UINib(nibName: "NewsTablePhotoCell", bundle: nil), forCellReuseIdentifier: "NewsPhotoCell")
        tableView.register(UINib(nibName: "NewsTableActionsCell", bundle: nil), forCellReuseIdentifier: "NewsActionsCell")
        getNews()
    }
    func  getNews(){
        newsService.updateNews()
}
    func pairTableAndRealm(){
        

       
        notificationToken = vk_news?.observe { [weak self] (changes: RealmCollectionChange) in
  
            guard let tableView = self?.tableView else {return}
            switch changes{
            case .initial:
                tableView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertion, modifications: let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertion.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


