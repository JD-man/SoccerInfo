//
//  NewsTableViewCell.swift
//  SoccerInfo
//
//  Created by JD_MacMini on 2021/11/25.
//

import UIKit
import Kingfisher
import SnapKit

final class NewsTableViewCell: UITableViewCell {
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let newsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private var newsImageInitialWidth: CGFloat = 120
    private var newsImageInitialLeftConstant: CGFloat = 15
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        [newsImageView, newsTitleLabel, newsDescriptionLabel].forEach {
            contentView.addSubview($0)
        }
        
        newsImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(120)
            make.centerY.equalToSuperview()
            make.height.equalTo(newsImageView.snp.width).multipliedBy(2.0/3.0)
        }
        
        newsTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(newsImageView.snp.trailing).offset(15)
            make.top.trailing.equalToSuperview().inset(15)
        }
        newsTitleLabel.snp.contentHuggingVerticalPriority = 252
        newsTitleLabel.snp.contentCompressionResistanceVerticalPriority = 752
        
        newsDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(newsTitleLabel)
            make.top.equalTo(newsTitleLabel.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
        }
    }
    
    func configure(with data: NewsData) {
        let newsImageState: NewsImageState = data.imageURL == nil ? .isEmpty : .isExist
        updateNewsImageViewConstarint(state: newsImageState)
        newsTitleLabel.text = data.title?.removeSearchTag
        newsDescriptionLabel.text = data.description?.removeSearchTag
        newsImageView.kf.setImage(with: URL(string: data.imageURL ?? ""))
    }
    
    private func updateNewsImageViewConstarint(state: NewsImageState) {
        newsImageView.snp.updateConstraints { make in
            make.width.equalTo(state.width)
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentView).offset(state.leftConstant)
            make.height.equalTo(newsImageView.snp.width).multipliedBy(2.0/3.0)
        }
    }
}

extension NewsTableViewCell {
    enum NewsImageState {
        case isExist
        case isEmpty
        
        var width: CGFloat {
            switch self {
            case .isEmpty: return 0
            case .isExist: return 120
            }
        }
        
        var leftConstant: CGFloat {
            switch self {
            case .isEmpty: return 0
            case .isExist: return 15
            }
        }
    }
}

