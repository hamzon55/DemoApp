import SnapKit
import Combine

struct HeroScreenViewModel: Equatable {
    public let heroes: [HeroItemCellViewModel]
}

struct HeroItemCellViewModel: Equatable {
    let name: String
    let description: String
    let characterImageURL: URL?
}

class HeroItemCell: UITableViewCell {
    static let cellID = "HeroItemCell"
    
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let characterImageView = UIImageView()
    private var cancellable: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }
    private func setupViews() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = UIColor.black
        nameLabel.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.numberOfLines = 5
        descriptionLabel.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .gray
        }
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.clipsToBounds = true
        characterImageView.layer.borderWidth = 2
        characterImageView.layer.borderColor = UIColor.white.cgColor
        [nameLabel, descriptionLabel, characterImageView].forEach { addSubview($0)}
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.topOffset)
            make.leading.equalToSuperview().offset(Spacing.leadingOffset)
            make.trailing.equalToSuperview().offset(Spacing.trailingOffset)
        }
        characterImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Spacing.topOffset)
            make.leading.equalToSuperview().offset(Spacing.leadingOffset)
            make.height.width.equalTo(Spacing.imageViewSize)
            make.bottom.lessThanOrEqualToSuperview().offset(Spacing.bottomOffset)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Spacing.topOffset)
            make.leading.equalTo(characterImageView.snp.trailing).offset(Spacing.imageLeadingOffset)
            make.trailing.lessThanOrEqualToSuperview().offset(Spacing.descriptionTrailingOffset)
        }
    }
    
    func configure(with viewModel: HeroItemCellViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        characterImageView.download(image: viewModel.characterImageURL)
    }
    
    private func cancelImageLoading() {
        characterImageView.image = nil
        cancellable?.cancel()
    }
}
