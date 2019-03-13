//
//  ViewController.swift
//  PlayingCard
//
//  Created by муса магсумов on 12/02/2019.
//  Copyright © 2019 Муса Магсумов. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    var deck = PlayingCArdDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    
    @IBOutlet weak var PlayingCardView: PlayingCardView!
    
    var faceUpCardViewsMatched:Bool{
        return faceUpCardViews.count == 2 && faceUpCardViews[0].rank == faceUpCardViews[1].rank && faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
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
        }
        
    }
    private var faceUpCardViews:[PlayingCardView]{
        return cardViews.filter({$0.isFaceUp && !$0.isHidden})
    }
    
    @objc func flipOverCard(_ recognizer:UITapGestureRecognizer){ 
        switch recognizer.state {
        case .ended:
            if let choosenCardView = recognizer.view as? PlayingCardView{
                UIView.transition(with: choosenCardView,
                                  duration: 0.6,
                                  options:[.transitionFlipFromLeft],
                                  animations: {
                                choosenCardView.isFaceUp = !choosenCardView.isFaceUp
                },completion:{ finished in
                    if self.faceUpCardViews.count == 2 {
                        self.faceUpCardViews.forEach{ cardView in
                            UIView.transition(
                                with: cardView,
                                duration: 0.6 ,
                                options:[.transitionFlipFromLeft],
                                animations: {
                                    cardView.isFaceUp = false
                            }
                            )
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

