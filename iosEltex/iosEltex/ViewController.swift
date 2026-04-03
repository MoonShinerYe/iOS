import UIKit

final class ViewController: UIViewController {
    
    private var tradingSimulator: TradingSimulator?
    private var tradeHistory: [TradeRecord] = []
    private var hasTradeHistory: Bool = false
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Спот Rub/USD"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencySegmentedControl: UISegmentedControl = {
        let items = ["RUB", "USD"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let balanceControlView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Размер баланса:"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let balanceSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 100
        slider.maximumValue = 1000
        slider.value = 200
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let balanceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "200.00"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stopLossView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stopLossLabel: UILabel = {
        let label = UILabel()
        label.text = "Стоп-профит:"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stopLossTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "80.00"
        textField.text = "80.00"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.layer.cornerRadius = 12
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет данных\nНажмите Run для начала торговли"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let runButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Run", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
        showNoDataState()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(contentView)
        
        contentView.addSubview(topContainerView)
        contentView.addSubview(mainContainerView)
        
        topContainerView.addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(currencySegmentedControl)
        
        mainContainerView.addSubview(settingsStackView)
        
        balanceControlView.addSubview(balanceLabel)
        balanceControlView.addSubview(balanceSlider)
        balanceControlView.addSubview(balanceValueLabel)
        settingsStackView.addArrangedSubview(balanceControlView)
        
        stopLossView.addSubview(stopLossLabel)
        stopLossView.addSubview(stopLossTextField)
        settingsStackView.addArrangedSubview(stopLossView)
        
        mainContainerView.addSubview(tableView)
        mainContainerView.addSubview(noDataLabel)
        
        mainContainerView.addSubview(runButton)
        
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TradeCell.self, forCellReuseIdentifier: "TradeCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleStackView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 8),
            titleStackView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 8),
            titleStackView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -8),
            titleStackView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -8),
            
            mainContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 16),
            mainContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            settingsStackView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            settingsStackView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            settingsStackView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            
            balanceControlView.heightAnchor.constraint(equalToConstant: 70),
            balanceLabel.leadingAnchor.constraint(equalTo: balanceControlView.leadingAnchor, constant: 16),
            balanceLabel.centerYAnchor.constraint(equalTo: balanceControlView.centerYAnchor),
            
            balanceValueLabel.trailingAnchor.constraint(equalTo: balanceControlView.trailingAnchor, constant: -16),
            balanceValueLabel.centerYAnchor.constraint(equalTo: balanceControlView.centerYAnchor),
            balanceValueLabel.widthAnchor.constraint(equalToConstant: 80),
            
            balanceSlider.leadingAnchor.constraint(equalTo: balanceLabel.trailingAnchor, constant: 16),
            balanceSlider.trailingAnchor.constraint(equalTo: balanceValueLabel.leadingAnchor, constant: -16),
            balanceSlider.centerYAnchor.constraint(equalTo: balanceControlView.centerYAnchor),
            
            stopLossView.heightAnchor.constraint(equalToConstant: 70),
            stopLossLabel.leadingAnchor.constraint(equalTo: stopLossView.leadingAnchor, constant: 16),
            stopLossLabel.centerYAnchor.constraint(equalTo: stopLossView.centerYAnchor),
            
            stopLossTextField.trailingAnchor.constraint(equalTo: stopLossView.trailingAnchor, constant: -16),
            stopLossTextField.centerYAnchor.constraint(equalTo: stopLossView.centerYAnchor),
            stopLossTextField.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: settingsStackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: runButton.topAnchor, constant: -20),
            
            noDataLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            noDataLabel.leadingAnchor.constraint(greaterThanOrEqualTo: tableView.leadingAnchor, constant: 20),
            noDataLabel.trailingAnchor.constraint(lessThanOrEqualTo: tableView.trailingAnchor, constant: -20),
            
            runButton.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            runButton.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            runButton.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            runButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        balanceSlider.addTarget(self, action: #selector(balanceSliderChanged), for: .valueChanged)
        runButton.addTarget(self, action: #selector(runButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func showNoDataState() {
        hasTradeHistory = false
        tableView.isHidden = true
        noDataLabel.isHidden = false
        tradeHistory.removeAll()
        tableView.reloadData()
    }
    
    private func showTradeHistory() {
        hasTradeHistory = true
        tableView.isHidden = false
        noDataLabel.isHidden = true
        tableView.reloadData()
    }
    
    private func generateTradeHistory() {
        tradeHistory.removeAll()
        
        let balance = Double(balanceSlider.value)
        let stopProfitValue = Double(stopLossTextField.text ?? "80") ?? 80
        let selectedCurrency = currencySegmentedControl.selectedSegmentIndex == 0 ? "RUB" : "USD"
        
        tradingSimulator = TradingSimulator(initialBalance: balance, currency: selectedCurrency)
        tradingSimulator?.setStopProfit(stopProfitValue)
        
        let simulator = tradingSimulator!
        
        for iteration in 1...30 {
            let price = Double.random(in: 60...100)
            let decision = simulator.makeDecision(price: price)
            
            var tradeRecord = TradeRecord(
                iteration: iteration,
                price: price,
                currency: selectedCurrency,
                type: decision,
                hasTradeExecuted: false
            )
            
            switch decision {
            case .buy:
                tradeRecord.hasTradeExecuted = true
                tradeRecord.tradeInfo = "Куплено по цене \(String(format: "%.2f", price)) \(selectedCurrency)"
                simulator.executeTrade(price: price)
                
            case .sell:
                if simulator.hasOpenPosition {
                    tradeRecord.hasTradeExecuted = true
                    if let entryPrice = simulator.currentPositionPrice {
                        let profit = simulator.calculateProfit(entryPrice: entryPrice, exitPrice: price)
                        tradeRecord.tradeInfo = "Продажа: \(String(format: "%.2f", entryPrice)) → \(String(format: "%.2f", price))\nПрибыль: \(String(format: "%.2f", profit)) \(selectedCurrency)"
                    }
                }
                simulator.executeTrade(price: price)
                
            case .hold:
                if simulator.hasOpenPosition {
                    tradeRecord.tradeInfo = "Ожидаем роста до \(String(format: "%.2f", stopProfitValue))"
                } else {
                    tradeRecord.tradeInfo = "Нет открытой позиции"
                }
                
            case .ignore:
                tradeRecord.tradeInfo = "Цена не подходит для входа"
            }
            
            tradeHistory.append(tradeRecord)
        }
        
        tradingSimulator?.printFinalResult()
    }
    
    @objc private func balanceSliderChanged() {
        let value = Double(balanceSlider.value)
        balanceValueLabel.text = String(format: "%.2f", value)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func runButtonTapped() {
        view.endEditing(true)
        generateTradeHistory()
        showTradeHistory()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradeHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TradeCell", for: indexPath) as? TradeCell else {
            return UITableViewCell()
        }
        
        let record = tradeHistory[indexPath.row]
        cell.configure(with: record)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let record = tradeHistory[indexPath.row]
        
        if record.type == .ignore || (record.type == .hold && !record.hasTradeExecuted) {
            return 70
        } else {
            return 110
        }
    }
}
