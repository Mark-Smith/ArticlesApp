//
//  Reducer.swift
//  SuasIOS
//
//  Created by Mark Smith on 17/12/2017.
//  Copyright © 2017 ___MARKSMITH___. All rights reserved.
//

import Foundation
import Suas


// Find article screen reducer
// Reducer reduces found article state
class FindArticleReducer: Reducer {
  var initialState: FoundArticles = FoundArticles(foundArticle: [])

  func reduce(state: FoundArticles, action: Action) -> FoundArticles? {
    
    if let action = action as? ArticlesFetchedFromNetwork {
      // New articles were fetched from the network
      var newState = state
      newState.foundArticle = newState.foundArticle + action.articles
      return newState
    }

    // If action is unknown return nil to signify that state did not change
    return nil
  }
}
