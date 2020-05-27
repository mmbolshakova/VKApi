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
    var getUserLike: Int? { get }
    var getComment: String? { get }
    var getShare: String? { get }
    var getViews: String?  { get }
    var photoAttach: FeedSetPhotoViewModel? { get }
    var sizes: FeedCellSizes { get }
    var getPostId: Int? { get }
    var getSourceId: Int? { get }
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

protocol CellDelegate {
    func didTapButton(index: Int)
}
class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heart: UIImageView!
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
    
    var cellDelegate: CellDelegate?
    var index: IndexPath = []
    
    struct ColorLike {
        static let redColor: UIColor = #colorLiteral(red: 0.9168686271, green: 0.2156980336, blue: 0, alpha: 1)
        static let grayColor: UIColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        cellDelegate?.didTapButton(index: index.row)
    }
    
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
        
        
        if viewModel.getUserLike == 1 {
            like.textColor = ColorLike.redColor
            like.font = UIFont.boldSystemFont(ofSize: 15)
            
            heart.image = UIImage(systemName: "heart.fill")
            heart.tintColor = ColorLike.redColor
        } else {
            like.textColor = ColorLike.grayColor
            like.font = UIFont.systemFont(ofSize: 15)
            
            heart.image = UIImage(systemName: "heart")
            heart.tintColor = ColorLike.grayColor
        }
        
        if let photoAttach = viewModel.photoAttach {
            postImg.set(imgageURL: photoAttach.photoUrl)
            postImg.isHidden = false
        }
        else {
            postImg.isHidden = true
        }
    }
}
