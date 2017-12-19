//
//  State.swift
//  ArticlesApp
//
//  Created by Mark Smith on 17/12/2017.
//  Copyright © 2017 ___MARKSMITH___. All rights reserved.
//

import UIKit
import Foundation
import SuasMonitorMiddleware

// Articles that are fetched from the network
struct FoundArticles: SuasEncodable {
  var foundArticle: [Article]
}

// Article information
struct Article: Decodable, SuasEncodable {
  var name: String
  var updated_at: Date
  var body: String
}



