import UIKit

class TradeCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iterationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tradeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(iterationLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(typeLabel)
        containerView.addSubview(separatorView)
        containerView.addSubview(tradeInfoLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            iterationLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            iterationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            priceLabel.centerYAnchor.constraint(equalTo: iterationLabel.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: iterationLabel.trailingAnchor, constant: 12),
            
            typeLabel.centerYAnchor.constraint(equalTo: iterationLabel.centerYAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            typeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            typeLabel.heightAnchor.constraint(equalToConstant: 28),
            
            separatorView.topAnchor.constraint(equalTo: iterationLabel.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            tradeInfoLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            tradeInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            tradeInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            tradeInfoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with record: TradeRecord) {
        iterationLabel.text = "Шаг \(record.iteration)"
        priceLabel.text = "\(String(format: "%.2f", record.price)) \(record.currency)"
        
        switch record.type {
        case .buy:
            typeLabel.text = "ПОКУПКА"
            typeLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            typeLabel.textColor = .systemGreen
        case .sell:
            typeLabel.text = "ПРОДАЖА"
            typeLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            typeLabel.textColor = .systemRed
        case .hold:
            typeLabel.text = "ДЕРЖИМ"
            typeLabel.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
            typeLabel.textColor = .systemOrange
        case .ignore:
            typeLabel.text = "ИГНОР"
            typeLabel.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            typeLabel.textColor = .systemGray
        }
        
        if record.hasTradeExecuted || (record.type == .hold && record.tradeInfo != nil) {
            tradeInfoLabel.text = record.tradeInfo
            tradeInfoLabel.isHidden = false
            separatorView.isHidden = false
        } else {
            tradeInfoLabel.isHidden = true
            separatorView.isHidden = true
        }
    }
}
