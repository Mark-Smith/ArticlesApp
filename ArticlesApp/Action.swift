//
//  Action.swift
//  ArticlesApp
//
//  Created by Mark Smith on 17/12/2017.
//  Copyright © 2017 ___MARKSMITH___. All rights reserved.
//

import Foundation
import Suas
import SuasMonitorMiddleware
import Alamofire


// Articles fetched
struct ArticlesFetchedFromNetwork: Action, SuasEncodable {
  var articles: [Article]
}

// Creates an action that fetches articles from the network
func createRequestArticlesAction(page: Int) -> Action {
    
    let urlString = "https://support.zendesk.com/api/v2/help_center/en-us/sections/200623776/articles.json"
    
    // Create a`BlockAsyncAction` async action that fetches the url
    // Check another sample implementation here -> https://gist.github.com/nsomar/b47642d52b95b39fd9daddcd36aaf333
    let action = BlockAsyncAction { (getState, dispatch) in
        Alamofire.request(urlString, parameters: ["page": String(page), "per_page": String(30)], encoding: URLEncoding.default)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    // see: https://stackoverflow.com/questions/42543007/how-to-solve-string-interpolation-produces-a-debug-description-for-an-optional
                    print("Error while fetching articles: \(response.result.error)")
                    //completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["articles"] as? [[String: Any]] else {
                        print("Malformed data received from service")
                        //completion(nil)
                        return
                }
                
                //let isoDate = "2016-04-14T10:44:00+0000"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                // Create a list of articles from the JSON
                let articles = rows.map({
                    Article(name: $0["name"] as! String,
                            updated_at: dateFormatter.date(from: $0["updated_at"] as! String)!,
                            body: $0["body"] as! String
                    )
                })
                
                dispatch(ArticlesFetchedFromNetwork(articles: articles))
                
            }.resume()
    }
    
    return action
}

