//
//  FlickrHomeFotterCollectionReusableView.swift
//  FlickerDemo
//
//  Created by RailYatri on 06/02/19.
//  Copyright © 2019 MoharSingh. All rights reserved.
//

import UIKit

class FlickrHomeFotterCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var loadMoreBtn: UIButton!
    @IBOutlet weak var totalLoadedPageLbl: UILabel!
    @IBOutlet weak var perPageLbl: UILabel!
    @IBOutlet weak var totalPageLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
