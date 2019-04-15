//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by муса магсумов on 14/03/2019.
//  Copyright © 2019 Муса Магсумов. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior:UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior:UIDynamicItemBehavior = {
        let behavior  = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        
        return behavior
    }()
    
    lazy var gravityBehavior:UIGravityBehavior = {
        let behavior  = UIGravityBehavior()
        behavior.magnitude = 0
        return behavior
        
    }()
    
    func push (_ item:UIDynamicItem){
        let push  = UIPushBehavior(items: [item], mode: .instantaneous )
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        push.action = {[unowned push,weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
        
    }
    
    func addItem(_ item:UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        gravityBehavior.addItem(item)
        push(item)
    }
    func removeItem(_ item:UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
        gravityBehavior.removeItem(item)
        push(item)
    }
    override init(){
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
        addChildBehavior(gravityBehavior)
    }
    convenience init(in animator: UIDynamicAnimator ){
        self.init()
         animator.addBehavior(self)
    }
    
}
extension CGFloat{
    var arc4random: CGFloat {
        if self > 0.0 {
            return CGFloat(arc4random_uniform(UInt32(self))) }
        else if self < 0.0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0.0
        }
    }
}





