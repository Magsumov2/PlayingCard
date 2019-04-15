//
//  ViewController.swift
//  PlayingCard
//
//  Created by муса магсумов on 12/02/2019.
//  Copyright © 2019 Муса Магсумов. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController{
    
    var deck = PlayingCArdDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior.init(in: animator)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2){
            let card = deck.draw()!
            cards += [card,card]
        }
        for cardView in cardViews{
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(flipOverCard)))
            cardBehavior.addItem(cardView)
            
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CMMotionManager.shared.isAccelerometerAvailable{
            cardBehavior.gravityBehavior.magnitude = 1.0
            CMMotionManager.shared.accelerometerUpdateInterval = 1/10
            CMMotionManager.shared.startAccelerometerUpdates(to: .main) { data ,error in
                if var x = data?.acceleration.x{
                    if var y = data?.acceleration.y{
                        switch UIDevice.current.orientation{
                        case .portrait: y *= -1
                        case .portraitUpsideDown:
                            break
                        case .landscapeLeft:
                            swap(&x, &y)
                        case .landscapeRight:
                            swap(&x, &y)
                            y *= -1
                        default : x = 0
                                  y = 0
                        }
                        self.cardBehavior.gravityBehavior.gravityDirection = CGVector(dx: x, dy: y)
                        
                    }
                }
                
            }
        }
    }
    var faceUpCardViewsMatched:Bool{
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    private var faceUpCardViews:[PlayingCardView]{
        return cardViews.filter {$0.isFaceUp && !$0.isHidden }
    }
    
    @objc func flipOverCard(_ recognizer:UITapGestureRecognizer){ 
        switch recognizer.state {
        case .ended:
            if let choosenCardView = recognizer.view as? PlayingCardView{
                cardBehavior.removeItem(choosenCardView)
                UIView.transition(with: choosenCardView,
                                  duration: 0.6,
                                  options:[.transitionFlipFromLeft],
                                  animations: {
                                    choosenCardView.isFaceUp = !choosenCardView.isFaceUp
                },completion:{ finished in
                    if self.faceUpCardViewsMatched{
                        if #available(iOS 10.0, *) {
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                                           delay: 0,
                                                                           options: [],
                                                                           animations: {
                                                                            self.faceUpCardViews.forEach({
                                                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                                            })
                            },completion:{ posiotion in
                                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75,
                                                                               delay: 0,
                                                                               options: [],
                                                                               animations: {
                                                                                self.faceUpCardViews.forEach({$0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                                                    $0.alpha = 0
                                                                                })
                                },
                                                                               completion: { position in
                                                                                self.faceUpCardViews.forEach({ $0.isHidden = true
                                                                                    $0.alpha = 1
                                                                                    $0.transform = .identity
                                                                                })})
                                
                            })
                        } else {
                            // Fallback on earlier versions
                        }
                    }else if self.faceUpCardViews.count == 2 {
                        self.faceUpCardViews.forEach{ cardView in
                            UIView.transition(
                                with: cardView,
                                duration: 0.6 ,
                                options:[.transitionFlipFromLeft],
                                animations: {
                                    cardView.isFaceUp = false
                            },completion: { finished in
                                self.cardBehavior.addItem(cardView)
                                })
                            
                        }
                    }else{
                        if !choosenCardView.isFaceUp{
                            self.cardBehavior.addItem(choosenCardView)
                        }
                    }
                }
                )
            }
        default:
            break
        }
        
    }
    
    
}

