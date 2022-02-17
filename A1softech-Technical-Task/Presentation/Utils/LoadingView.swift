//
//  LoadingView.swift
//  A1softech-Technical-Task
//
//  Created by Mohamed El-Naggar on 2/15/22.
//

import UIKit

class LoadingView: UIActivityIndicatorView {

    var isLoading = false {
        didSet { isLoading ? startAnimating() : stopAnimating() }
    }
}
