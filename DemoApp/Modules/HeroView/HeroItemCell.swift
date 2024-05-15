//
//  HeroItemCell.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 11/5/24.
//

import UIKit
import SnapKit

class HeroItemCell: UITableViewCell {
    static let cellID = "HeroItemCell"

    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let characterImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        characterImageView.cancelDownloading()
    }
    
    private func setupViews() {
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18) 
        nameLabel.textColor = UIColor.black
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.numberOfLines = 5

        characterImageView.contentMode = .scaleAspectFill
        characterImageView.clipsToBounds = true
        characterImageView.layer.borderWidth = 2
        characterImageView.layer.borderColor = UIColor.white.cgColor
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(characterImageView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(150)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(characterImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-18)
        }
    }
    
    func configure(with item: Character) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        characterImageView.download(image: item.thumbnail.url)
    }
}
