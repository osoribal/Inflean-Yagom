//
//  UserInfo.swift
//  DISCTest
//
//  Created by yagom
//  Copyright © 2017년 yagom. All rights reserved.
//

import Foundation

class UserInfo {
    /// for Singleton design pattern
    static let shared: UserInfo = UserInfo()
    
    // Instance Properties
    var name: String!
    let score: Score = Score()
    
    var hightestScoreResult: Result.Info? {
        let hightest: Int = max(self.score.d, self.score.i, self.score.s, self.score.c)
        switch hightest {
        case self.score.d:
            return Result.shared?.d
        case self.score.i:
            return Result.shared?.i
        case self.score.s:
            return Result.shared?.s
        default:
            return Result.shared?.c
        }
    }
    
    var scorePercentageText: String {
        
        let sum: Double = Double(self.score.d + self.score.i + self.score.s + self.score.c)
        let percentageD = Double(self.score.d) / sum * 100
        let percentageI = Double(self.score.i) / sum * 100
        let percentageS = Double(self.score.s) / sum * 100
        let percentageC = Double(self.score.c) / sum * 100
        
        return String(format: "D : %.0lf%%, I : %.0lf%%, S : %.0lf%%, C : %.0lf%%", percentageD, percentageI, percentageS, percentageC)
    }
}

extension UserInfo {
    
    class Score {
        var d: Int = 0
        var i: Int = 0
        var s: Int = 0
        var c: Int = 0
    }
    
    func reset() {
        self.score.d = 0
        self.score.i = 0
        self.score.s = 0
        self.score.c = 0
        self.name = nil
    }
    
    enum ScoreType {
        case d, i, s, c
    }
}
