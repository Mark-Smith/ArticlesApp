//
//  ArticleCell.swift
//  ArticlesApp
//
//  Created by Mark Smith on 17/12/2017.
//  Copyright © 2017 ___MARKSMITH___. All rights reserved.
//

import UIKit
import WebKit

class ArticleCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var bodyWebView: WKWebView!
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var bodyView: UIView!
    
    /*override init(style: style, reuseIdentifier: reuseIdentifier) {
     @IBOutlet weak var bodyView: UIView!
     super.init(style: UITableViewCellStyle, reuseIdentifier: <#T##String?#>)
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //bodyWebView?.scrollView.zoomScale = 2
    }
}
