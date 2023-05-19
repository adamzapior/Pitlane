//
//  F1AlertVC.swift
//  F1 Stats
//
//  Created by Adam Zapiór on 18/12/2022.
//

import UIKit

class F1AlertVC: UIViewController {

    let containerView   = UIView()
    let titleLabel      = F1TitleLabel(textAlignnment: .center, fontSize: 20)
    let messageLabel    = F1BodyLabel(textAlignnment: .center)
    let actionButton    = F1MainButton(backgroundColor: .systemPink, title: "OK")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20 //constant - padding to change the design assets on Container View
    
    // MARK: by code you can call alert in VC:
    //
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = title
        self.message        = message
        self.buttonTitle    = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75) // Opacity
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    // MARK: - Container View: View Setup
    func configureContainerView() {
        view.addSubview(containerView)
        containerView.backgroundColor    = .systemBackground
        containerView.layer.cornerRadius = 16
        
        containerView.layer.borderWidth  = 2
        containerView.layer.borderColor  = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // put container center to screen:
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),   // center to Y
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),   // center to X
            containerView.widthAnchor.constraint(equalToConstant: 280),            //window size
            containerView.heightAnchor.constraint(equalToConstant: 220)            //window size
        ])
    }

    // MARK: - ASSETS on Container View: View Setup
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        
    }
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dissmissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text           = message ?? "Unable to complete request"
        messageLabel.numberOfLines  = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -20),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: padding)
        ])
    }
    
    
    @objc func dissmissVC() {
        dismiss(animated: true)
    }
}
