//
//  GaleryViewController.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 03/02/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit

class GaleryViewController: UIViewController {
 var index = 0
    @IBOutlet weak var fotoGalery: UIImageView!
    
    @IBOutlet weak var buttomBack: UIBarButtonItem!
    var friendsFoto = [ ["Bredly":"Брэдли Купер"],["Bredly_1":"Брэдли Купер"],["Russel":"Рассел Кроу"],["Russel_1":"Рассел Кроу"],["Richard":"Ричард Гир"],["Richard_1":"Ричард Гир"],["Leonardo":"Леонардо ди Каприо"],["Leonardo_1":"Леонардо ди Каприо"]]
    override func viewDidLoad() {
        super.viewDidLoad()

       fotoGalery.image = UIImage(named: Array(friendsFoto[0])[0].key)
        //left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        //right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        //up
        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        swipeUP.direction = .up
        self.view.addGestureRecognizer(swipeUP)
        //down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        // buttomBack.doesNotRecognizeSelector(,
        // Do any additional setup after loading the view.
    }
    
    @objc func onSwipe(_ recognizer:UISwipeGestureRecognizer){
       
        
        switch recognizer.direction {
        case .right:
            if index == 0{
                index = friendsFoto.count-1
            } else { index -= 1}
            //fotoGalery.image = UIImage(named: Array(friendsFoto[index])[0].key)
            swipeRight()
            
        case .left:
            if index == friendsFoto.count-1{
                index = 0
            } else { index += 1}
           // fotoGalery.image = UIImage(named: Array(friendsFoto[index])[0].key)
            swipeLeft()
            
        case .down:
        
            if index == 0{
                index = friendsFoto.count-1
            } else { index -= 1}
            fotoGalery.image = UIImage(named: Array(friendsFoto[index])[0].key)
           // self.dismiss(animated: true, completion: nil)
            
        case .up:
        
            if index == friendsFoto.count-1{
                index = 0
            } else { index += 1}
            fotoGalery.image = UIImage(named: Array(friendsFoto[index])[0].key)
            // self.dismiss(animated: true, completion: nil)
        default: return
        
        }
    }
    @IBAction func goBack(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func swipeRight() {
        UIView.animateKeyframes(withDuration: 0.8,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        
                                                        let animation = CABasicAnimation(keyPath: "position.x")
                                                        animation.fromValue = self.fotoGalery.layer.bounds.origin.x
                                                        animation.toValue = self.fotoGalery.layer.bounds.origin.x + 200
                                                        animation.duration = 0.6
                                                        self.fotoGalery.layer.add(animation, forKey: nil)
                                                        
                                                        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                                                        opacityAnimation.fromValue = 0
                                                        opacityAnimation.toValue = 1
                                                        opacityAnimation.duration = 0.6
                                                        self.fotoGalery.layer.add(opacityAnimation, forKey: nil)
                                                        
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                       relativeDuration: 0.8,
                                                       animations: {
                                                        //
                                                        let animation = CABasicAnimation(keyPath: "transform.scale")
                                                        animation.fromValue = 0.4
                                                        animation.toValue = 1
                                                        animation.duration = 0.8
                                                        self.fotoGalery.layer.add(animation, forKey: nil)
                                                        
                                    })
                                   
                                    
        }, completion: {[weak self] finished in
            self!.fotoGalery.image = UIImage(named: Array(self!.friendsFoto[self!.index])[0].key)
            self!.fotoGalery.transform = .identity})
    }

    private func swipeLeft() {
        UIView.animateKeyframes(withDuration: 0.8,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        
                                                        let animation = CABasicAnimation(keyPath: "position.x")
                                                        animation.fromValue = self.fotoGalery.layer.bounds.origin.x+400
                                                        animation.toValue = self.fotoGalery.layer.bounds.origin.x+200
                                                        animation.duration = 0.6
                                                        self.fotoGalery.layer.add(animation, forKey: nil)
                                                        
                                                        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                                                        opacityAnimation.fromValue = 0
                                                        opacityAnimation.toValue = 1
                                                        opacityAnimation.duration = 0.6
                                                        self.fotoGalery.layer.add(opacityAnimation, forKey: nil)
                                                        
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                       relativeDuration: 0.8,
                                                       animations: {
                                                        //
                                                        let animation = CABasicAnimation(keyPath: "transform.scale")
                                                        animation.fromValue = 0.4
                                                        animation.toValue = 1
                                                        animation.duration = 0.8
                                                        self.fotoGalery.layer.add(animation, forKey: nil)
                                                        
                                    })
                                    
        }, completion: {[weak self] finished in
//            var counter: Int {
//                if self!.index == self!.friendsFoto.count - 1 {return 0}
//                else {return self!.index + 1}
//            }
            self!.fotoGalery.image = UIImage(named: Array(self!.friendsFoto[self!.index])[0].key)
            //self!.fotoGalery.image = UIImage(named: Array(self!.friendsFoto[counter])[0].key)
            self!.fotoGalery.transform = .identity})
    }

}
