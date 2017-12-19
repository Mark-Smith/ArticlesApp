//
//  MasterViewController.swift
//  ArticlesApp
//
//  Created by Mark Smith on 17/12/2017.
//  Copyright © 2017 ___MARKSMITH___. All rights reserved.
//

import UIKit


class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    let cellReuseIdentifier = "ArticleCell"
    var curPage: Int = 1
    
    var isDataLoading:Bool=false
    var didEndReached:Bool=false
    
    // Articles are loaded from the store state by default
    var foundArticles: FoundArticles = store.state.value(forKeyOfType: FoundArticles.self)! {
        didSet {
            // Reload table when state changes
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Add a listener and link the listener lifecycle to self
        // When self is deallocated the reducer is removed
        // Notice: we use [weak self] to prevent retain cycles
        store.addListener(forStateType: FoundArticles.self) { [weak self] state in
            self?.foundArticles = state
            }.linkLifeCycleTo(object: self)
        
        // Add an action listener and link the listener lifecycle to self
        // When self is deallocated the reducer is removed
        // Notice: we use [weak self] to prevent retain cycles
        store.addActionListener { [weak self] action in
            
            
            }.linkLifeCycleTo(object: self)
        
        store.dispatch(action: createRequestArticlesAction(page: curPage))
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundArticles.foundArticle.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ArticleCell
        cell.nameLabel?.text = foundArticles.foundArticle[indexPath.row].name
        
        //let dateString = "Thu, 22 Oct 2015 07:45:17 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        // create attributed string
        let updatedAtString = "Last updated: " + dateFormatter.string(from: foundArticles.foundArticle[indexPath.row].updated_at)
        let attributes: [ String : Any ] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular),
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        let updatedAtAttrString = NSMutableAttributedString(string: updatedAtString, attributes: attributes)
        updatedAtAttrString.addAttributes([ NSForegroundColorAttributeName: UIColor.darkGray], range: NSRange(location: 12, length: updatedAtAttrString.length-12))

        // set attributed text on a UILabel
        cell.updatedAtLabel?.attributedText = updatedAtAttrString
        
        cell.bodyWebView.scrollView.zoomScale = 2
        cell.bodyWebView.loadHTMLString(foundArticles.foundArticle[indexPath.row].body, baseURL: nil)
        //cell.bodyWebView.snapshotView(afterScreenUpdates: true)
        cell.bodyView = cell.bodyWebView.snapshotView(afterScreenUpdates: false)
        
        return cell
    }
    
    /*func getImage(context: ServiceExecuteContext) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(context.fromViewController.webView.bounds.size, true, 0)
        for subView: UIView in context.fromViewController.webView.subviews {
            subView.drawViewHierarchyInRect(subView.bounds, afterScreenUpdates: true)
        }
        //UIApplication.sharedApplication().keyWindow?.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //let imagRef = CGImageCreateWithImageInRect((image?.CGImage)!, context.fromViewController.webView.bounds)
        //let newImage = UIImage.init(CGImage: imagRef!)
        
        return image!
    }*/
    
    // MARK: - Scroll View
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        //let tableViewContentOffsetY = tableView.contentOffset.y
        //let tableViewFrameSizeHeight = tableView.frame.size.height
        //let tableViewContentSizeHeight = tableView.contentSize.height
        if ((tableView.contentOffset.y + tableView.frame.size.height) > tableView.contentSize.height - 110)
        {
            if !isDataLoading{
                isDataLoading = true
                curPage+=1
                store.dispatch(action: createRequestArticlesAction(page: curPage))
            }
        }
        
        
    }

}

