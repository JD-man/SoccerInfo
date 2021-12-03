//
//  NewsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/25.
//

import UIKit
import Kingfisher


class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    @IBOutlet weak var newsImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var newsImageViewLeftConstraint: NSLayoutConstraint!
    
    private var newsImageInitialWidth: CGFloat = 0
    private var newsImageInitialLeftConstant: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewConfig()
    }
    
    func viewConfig() {
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 10
        
        newsTitleLabel.numberOfLines = 1
        newsTitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        newsDescriptionLabel.numberOfLines = 3
        newsDescriptionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        newsDescriptionLabel.textColor = .systemGray2        
        
        newsImageInitialWidth = newsImageView.frame.width
        newsImageInitialLeftConstant = newsImageViewLeftConstraint.constant        
    }
    
    func configure(with data: NewsData) {
        newsImageViewWidthConstraint.constant = data.imageURL == nil ? 0 : newsImageInitialWidth
        newsImageViewLeftConstraint.constant = data.imageURL == nil ? 0 : newsImageInitialLeftConstant
        
        newsImageView.kf.setImage(with: URL(string: data.imageURL ?? ""))
        newsTitleLabel.text = data.title?.removeSearchTag
        newsDescriptionLabel.text = data.description?.removeSearchTag
    }
}
