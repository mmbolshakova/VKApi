//
//  TableViewCellXib.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 12.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import UIKit

protocol FeedCellViewModel {
    var getIconUrl: String { get }
    var getName: String { get }
    var getDate: String { get }
    var getNewsText: String? { get }
    var getLike: String? { get }
    var getComment: String? { get }
    var getShare: String? { get }
    var getViews: String?  { get }
    var photoAttach: FeedSetPhotoViewModel? { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellSizes {
    var newsTextFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
}

protocol FeedSetPhotoViewModel {
    var photoUrl: String { get }
    var photoHeight: Int { get }
    var photoWidth: Int { get }
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mainViewCell: UIView!
    @IBOutlet weak var icon: WebImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var postImg: WebImageView!
    @IBOutlet weak var share: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    static let cellId = "cellXib"
    static var nib: UINib {
        return UINib(nibName: "NewsTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        icon.layer.cornerRadius = icon.frame.width / 2
        icon.clipsToBounds = true
        
        mainViewCell.clipsToBounds = true
        backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func set(viewModel: FeedCellViewModel){
        icon.set(imgageURL: viewModel.getIconUrl)
        name.text = viewModel.getName
        date.text = viewModel.getDate
        newsText.text = viewModel.getNewsText
        share.text = viewModel.getShare
        like.text = viewModel.getLike
        comment.text = viewModel.getComment
        views.text = viewModel.getViews
        
        postImg.translatesAutoresizingMaskIntoConstraints = true
        postImg.frame = viewModel.sizes.attachmentFrame
        
        if let photoAttach = viewModel.photoAttach {
            postImg.set(imgageURL: photoAttach.photoUrl)
            postImg.isHidden = false
        }
        else {
            postImg.isHidden = true
        }
    }
}
