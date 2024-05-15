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
        // Customize cell appearance
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterImageView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        characterImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(100)
        }
    }
    
    func configure(with item: Character) {
        nameLabel.text = item.name
        characterImageView.download(image: item.thumbnail.url)
    }
}
