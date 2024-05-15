//
//  HeroItemCell.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 11/5/24.
//

import UIKit
import SnapKit

class HeroItemCell: UITableViewCell {
    
    let nameLabel = UILabel()
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
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18) // Increase font size
        nameLabel.textColor = UIColor.black
        
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.clipsToBounds = true
        characterImageView.layer.borderWidth = 2
        characterImageView.layer.borderColor = UIColor.white.cgColor
        
        contentView.addSubview(nameLabel)
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
    }
    
    func configure(with item: Character) {
        nameLabel.text = item.name
        characterImageView.download(image: item.thumbnail.url)
    }
}
