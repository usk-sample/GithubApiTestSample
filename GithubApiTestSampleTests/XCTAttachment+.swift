//
//  XCTAttachment+.swift
//  GithubApiTestSampleTests
//
//  Created by Yusuke Hasegawa on 2021/08/03.
//

import Foundation
import XCTest

extension XCTAttachment {
    
    func setLifetime(_ lifetime: Lifetime) -> XCTAttachment {
        self.lifetime = lifetime
        return self
    }
    
}
