//
//  UIRefreshController+Helper.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/18/23.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
