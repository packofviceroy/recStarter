//
//  ButtonViewController.swift
//  recStarter
//
//  Created by dumbo on 6/17/24.
//

import UIKit
class ButtonViewController: UIViewController {
    private var running = false
    private var _buttonText = "START"
    private var _startTime = Date.now
    private var _timeText = "00:00:00.000"
    var timer = Timer()
    
    
    private var stackView:UIStackView = {
        let sview = UIStackView()
        sview.axis = .vertical
        sview.spacing = 10
        sview.alignment = .center
        sview.distribution = .equalSpacing
        sview.translatesAutoresizingMaskIntoConstraints = false
        return sview
    }()

    private var timerLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00:00.000"
        label.font = .systemFont(ofSize: 55)
        label.textColor = .white
        return label
    }()
    
    private var startButton : UIButton = {
        let button = UIButton()
        button.setTitle("START", for: .normal)
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 400).isActive = true
        button.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        button.titleLabel?.font = .systemFont(ofSize: 70)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .focused)
        button.backgroundColor = .white
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                     selector: #selector(reloadTimerText), userInfo: nil, repeats: true)

        view.addSubview(stackView)
        setupNavigationController()
        setupStackView()
        setupConstraints()
        setupButton()
    }
    
    func setupNavigationController(){
        navigationItem.title = "Button"
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                     style: .done,
                                     target: self,
                                     action: #selector(goBackHome))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = button
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    @objc
    func goBackHome(){
        
    }
    
    @objc
    func reloadTimerText(){
        if running{
            let _timeInterval = Date().timeIntervalSince(_startTime)
            timerLabel.text = _timeInterval.stringFromTimeInterval()
        }
    }
    
    
    func setupStackView(){
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(timerLabel)
    }
    
    func setupConstraints(){
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor
                                       ,constant: 30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
    }
    
    func setupButton(){
        startButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        startButton.frame = CGRect(x: self.view.frame.width/2/2,
                                   y: self.view.frame.height/2,
                                   width: 650,
                                   height: 1500)
    }
    
    
    @objc
    func buttonAction(){
        running.toggle()
        if running{
            startButton.setTitle("STOP", for: .normal)
            _startTime = Date.now
        }else{
            startButton.setTitle("START", for: .normal)
            _startTime = Date.now
        }

    }
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}
