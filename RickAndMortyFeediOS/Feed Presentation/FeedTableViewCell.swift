//
//  FeedTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/7/23.
//

import Foundation
import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet private(set) weak var name: UILabel!
    @IBOutlet private(set) weak var species: UILabel!
    @IBOutlet private(set) weak var status: UILabel!
    @IBOutlet private(set) weak var type: UILabel!
    @IBOutlet private(set) weak var contentImage: UIImageView!
}
