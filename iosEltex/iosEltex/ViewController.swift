import UIKit

final class ViewController: UIViewController {
    
    private var tradingSimulator: TradingSimulator?
    private let initialBalance: Double = 200.0
    private var originalStdout: Int32?
    private var pipe: Pipe?
    
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
        return label
    }()
    
    private let currencySegmentedControl: UISegmentedControl = {
        let items = ["RUB", "USD"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
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
    
    private let outputScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        scrollView.layer.cornerRadius = 12
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let outputTextView: UITextView = {
        let textView = UITextView()
        textView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
        setupActions()
        setupInitialOutput()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(topContainerView)
        view.addSubview(mainContainerView)
        
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
        
        outputScrollView.addSubview(outputTextView)
        mainContainerView.addSubview(outputScrollView)
        
        mainContainerView.addSubview(runButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleStackView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 8),
            titleStackView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 8),
            titleStackView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -8),
            titleStackView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -8),
            
            // Основной контейнер
            mainContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 16),
            mainContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
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
            
            outputScrollView.topAnchor.constraint(equalTo: settingsStackView.bottomAnchor, constant: 20),
            outputScrollView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            outputScrollView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            outputScrollView.bottomAnchor.constraint(equalTo: runButton.topAnchor, constant: -20),
            
            outputTextView.topAnchor.constraint(equalTo: outputScrollView.topAnchor, constant: 12),
            outputTextView.leadingAnchor.constraint(equalTo: outputScrollView.leadingAnchor, constant: 12),
            outputTextView.trailingAnchor.constraint(equalTo: outputScrollView.trailingAnchor, constant: -12),
            outputTextView.bottomAnchor.constraint(equalTo: outputScrollView.bottomAnchor, constant: -12),
            outputTextView.widthAnchor.constraint(equalTo: outputScrollView.widthAnchor, constant: -24),
            
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
    
    private func setupInitialOutput() {
        outputTextView.text = "Готов к запуску \nНажмите Run для начала торговли\n"
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
        

        let balance = Double(balanceSlider.value)
        let stopProfitValue = Double(stopLossTextField.text ?? "80") ?? 80
        let selectedCurrency = currencySegmentedControl.selectedSegmentIndex == 0 ? "RUB" : "USD"
        

        tradingSimulator = TradingSimulator(initialBalance: balance, currency: selectedCurrency)
        tradingSimulator?.setStopProfit(stopProfitValue)
        

        outputTextView.text = ""
        appendToOutput("=== ЗАПУСК ТОРГОВОГО БОТА ===\n")
        

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            

            let originalStdout = dup(STDOUT_FILENO)
            

            let pipe = Pipe()
            dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
            

            pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
                let data = handle.availableData
                if let output = String(data: data, encoding: .utf8), !output.isEmpty {
                    DispatchQueue.main.async {
                        self?.appendToOutput(output.trimmingCharacters(in: .newlines))
                    }
                }
            }
            
            self.tradingSimulator?.runSimulation(iterations: 10, priceRange: 60...100)
            self.tradingSimulator?.printFinalResult()
            
            fflush(stdout)
            dup2(originalStdout, STDOUT_FILENO)
            close(originalStdout)
            pipe.fileHandleForReading.readabilityHandler = nil
            pipe.fileHandleForWriting.closeFile()
            
            DispatchQueue.main.async {
                self.appendToOutput("\n РАБОТА ЗАВЕРШЕНА")
            }
        }
    }
    
    private func appendToOutput(_ text: String) {
        DispatchQueue.main.async {
            let currentText = self.outputTextView.text ?? ""
            self.outputTextView.text = currentText + text + "\n"

            
            let range = NSRange(location: self.outputTextView.text.count - 1, length: 1)
            self.outputTextView.scrollRangeToVisible(range)
        }
    }
}
