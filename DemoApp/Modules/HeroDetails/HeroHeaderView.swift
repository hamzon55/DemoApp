import Foundation
import UIKit

class HeroHeaderView: UIView {
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Initializers
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupView()
       }
    
    private func setupView() {
            backgroundColor = .green
            layer.cornerRadius = 10
            addSubview(titleLabel)
            
            // Setup constraints
            setupConstraints()
        }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // Center the label horizontally and vertically
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    
            ])
        }
    
    func apply(viewModel: HeroItemCellViewModel) {
        titleLabel.text = viewModel.name

       }
    }

