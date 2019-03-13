//
//  File.swift
//  PlayingCard
//
//  Created by муса магсумов on 12/02/2019.
//  Copyright © 2019 Муса Магсумов. All rights reserved.
//

import Foundation
struct  PlayingCard:CustomStringConvertible {
    var description: String{ return "\(rank)\(suit) "}
    
    var suit:Suit
    var rank:Rank
    
    enum Suit: String,CustomStringConvertible {
        var description: String{
            switch self {
            case .spaids:return "♠️"
            case .clubs:return  "♣️"
            case .hearts:return "❤️"
            case .diamonds:return "♦️"
            }
        }
        
        case spaids = "♠️"
        case clubs = "♣️"
        case hearts = "❤️"
        case diamonds = "♦️"
        
        static var all = [Suit.spaids,.clubs,.hearts,.diamonds]
        
    }
    enum Rank:CustomStringConvertible{
        var description: String{
            switch self {
            case .ace: return String("A")
            case .numeric(let pips):return String(pips)
            case .face(let kind):return String(kind)
            }

        }
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips):return pips
            case .face(let kind) where kind == "J" :return 11
            case .face(let kind) where kind == "Q" :return 12
            case .face(let kind) where kind == "k": return 13
            default: return 0
            }
        }
        static var all:[Rank]{
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks+=[Rank.face("J"),.face("Q"),.face("K")]
            return allRanks
        }
        
    }
}


