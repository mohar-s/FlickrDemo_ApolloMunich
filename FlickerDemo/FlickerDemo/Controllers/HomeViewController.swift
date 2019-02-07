//
//  HomeViewController.swift
//  FlickerDemo
//
//  Created by RailYatri on 06/02/19.
//  Copyright © 2019 MoharSingh. All rights reserved.
//

import UIKit
import FlickrKit
import SDWebImage
import Alamofire


class HomeViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var flickrCollectionview: UICollectionView!
    
    var searchText : String = "nature"
    var perpage : Int = 20
    var pages : Int = 0
    var total : Int = 0
    var currentpageIndex : Int = 1
    
    var isLoading : Bool = true
    
    
    let photosArr  : NSMutableArray = NSMutableArray()
    var searchBar : UISearchBar!
    var footer : FlickrHomeFotterCollectionReusableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
//        getFlickrImages()
        getimagesUsingAlamofire()
        flickrCollectionview.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailsSegue"{
            let index = sender as! Int
            let photoData = self.photosArr[index] as! [String: AnyObject]
            let vc = segue.destination as! FlickrImageDetailsViewController
            vc.photoData = photoData
            //Data has to be a variable name in your RandomViewController
        }
    }
    
    
    //MARK: - IBActions
    @IBAction func searchBtnAction(_ sender: UIButton) {
        
        if self.searchBar.canResignFirstResponder {
            self.searchBar.resignFirstResponder()
        }
        
        searchText = self.searchBar.text!
        isLoading = true
        photosArr.removeAllObjects()
        flickrCollectionview.reloadData()
        //            getFlickrImages()
        getimagesUsingAlamofire()
        
    }
    @IBAction func getMoreImagesBtnAction(_ sender: UIButton) {
        
        if currentpageIndex < pages {
            currentpageIndex = currentpageIndex+1
            isLoading = true
            flickrCollectionview.reloadData()
//            getFlickrImages()
            getimagesUsingAlamofire()
        }
        else {
            FlickrUtils.showAlertIn(controller: self, title: "Flickr Demo", message: "All Photo loaded.")
        }
        
        
        
    }
    
    // 1st way to fetch Flickr images using Flickr URL API
    func getimagesUsingAlamofire()  {
        var urlStr = "\(AppConstants.apiBaseUrl)services/rest/?method=flickr.photos.search&api_key=\(AppConstants.FlickrApiKey)&text=\(searchText)&per_page=\(perpage)&format=json&nojsoncallback=1&page=\(currentpageIndex)"
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        
        let url = URL(string:urlStr)

        Alamofire.request(url!,
                          method: .get,
                          parameters: nil)
            .validate()
            .responseJSON { response1 in
                guard response1.result.isSuccess else {
                    print("Error while")
                    return
                }

                print(response1)

                // Load in main UI thread to refresh UI
                DispatchQueue.main.async {
                    let response = response1.result.value as? [String: AnyObject]
                    if let stat = response!["stat"] as? String {
                            if stat.lowercased() == "ok" {
                                
                                if let topPhotos = response!["photos"] as? [String: AnyObject] {
                                    if let perpage = topPhotos["perpage"] as? Int {
                                        self.perpage = perpage
                                    }
                                    if let pages = topPhotos["pages"] as? Int {
                                        self.pages = pages
                                    }
                                    if let total = topPhotos["total"] as? Int {
                                        self.total = total
                                    }
                                    if let page = topPhotos["page"] as? Int {
                                        self.currentpageIndex = page
                                    }
                                    
                                    if let photoArray = topPhotos["photo"] as? [[NSObject: AnyObject]] {
                                        self.photosArr.addObjects(from: photoArray)
                                    }
                                    
                                    self.flickrCollectionview.reloadData()
                                    self.isLoading = false
                                }
                            }
                            else {
                                FlickrUtils.showAlertIn(controller: self, title: "", message: "Not valied response")
                                self.isLoading = false
                            }
                            
                        }
                        else {
                            FlickrUtils.showAlertIn(controller: self, title: "", message: "Response Not found")
                            self.isLoading = false
                            
                        }
                }

                
        }
    }
    
    
    // 2nd way to fetch Flickr images using Flickr SDK
    func getFlickrImages()  {
        let flickrInteresting = FKFlickrInterestingnessGetList()
        flickrInteresting.per_page = "\(perpage)"
        flickrInteresting.page = "\(currentpageIndex)"
        FlickrKit.shared().call(flickrInteresting) { (response, error) -> Void in
            
            // Load in main UI thread to refresh UI
            DispatchQueue.main.async {
                if (response != nil) {
                    if let stat = response!["stat"] as? String {
                        if stat.lowercased() == "ok" {
                    
                            if let topPhotos = response!["photos"] as? [String: AnyObject] {
                                if let perpage = topPhotos["perpage"] as? Int {
                                    self.perpage = perpage
                                }
                                if let pages = topPhotos["pages"] as? Int {
                                    self.pages = pages
                                }
                                if let total = topPhotos["total"] as? Int {
                                    self.total = total
                                }
                                if let page = topPhotos["page"] as? Int {
                                    self.currentpageIndex = page
                                }
                                
                                if let photoArray = topPhotos["photo"] as? [[NSObject: AnyObject]] {
                                    self.photosArr.addObjects(from: photoArray)
                                }
                                
                                self.flickrCollectionview.reloadData()
                                self.isLoading = false
                            }
                        }
                        else {
                            FlickrUtils.showAlertIn(controller: self, title: "", message: "Not valied response")
                                self.isLoading = false
                        }

                    }
                    else {
                        FlickrUtils.showAlertIn(controller: self, title: "", message: "Response Not found")
                            self.isLoading = false

                    }
 
                }
            }
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
             let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FlickrHomeHeaderCollectionReusableViewIdentifier", for: indexPath) as! FlickrHomeHeaderCollectionReusableView
            self.searchBar = headerView.searchBar
             return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FlickrHomeFotterCollectionReusableViewIdentfier", for: indexPath) as! FlickrHomeFotterCollectionReusableView
            
            if isLoading {
                footerView.activityIndicator.isHidden = false
                footerView.activityIndicator.startAnimating()
                footerView.loadMoreBtn.setTitle("Loading...", for: .normal)
            }
            else {
                footerView.activityIndicator.isHidden = true
                footerView.activityIndicator.stopAnimating()
                if currentpageIndex >= pages {
                    footerView.loadMoreBtn.setTitle("All Photo loaded", for: .normal)
                }
                else {
                    footerView.loadMoreBtn.setTitle("Load More", for: .normal)
                }
            }
            
            footerView.totalLoadedPageLbl.text = "Total Loaded page : \(currentpageIndex)"
            footerView.perPageLbl.text = "Photo per page : \(perpage)"
            footerView.totalPageLbl.text = "Total page : \(pages)"
            
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrHomeCollectionCellIdentifier", for: indexPath) as! FlickrHomeCollectionCell
        
        let photoData = self.photosArr[indexPath.row] as! [String: AnyObject]
        cell.titleLabel.text = photoData["title"] as? String
        let photoURL = FlickrKit.shared().photoURL(for: .small240, fromPhotoDictionary: photoData)
        cell.flickrIv.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "loading_image.png"))
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionView : didSelectItemAt")
        let index = indexPath.row
        self.performSegue(withIdentifier: "ShowDetailsSegue", sender: index)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 15)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth =  140
        let itemHeight = 150
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //searchActive = false;
        self.searchBar.endEditing(true)
    }
    
}

