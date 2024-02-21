//
//  LoginVc.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 20/02/24.
//

import Foundation
import UIKit
import SnapKit
import MaterialComponents
import LocalAuthentication

class LoginVc: BaseVc {
    
    private let viewModel: BioViewModel = BioViewModel()
    var inputPhoneNumber: String = ""
    var inputPin: String = ""
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(LoginInputCell.self, forCellReuseIdentifier: "cell-login-input")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 21, left: 21, bottom: 0, right: 21))
        }
        
        // start init observer
        viewModel.liveLogin.subscribe(onNext: { data in
            self.hideWait()
            let nextVc = ViewController()
            nextVc.modalPresentationStyle = .overFullScreen
            self.present(nextVc, animated: true)
        }).disposed(by: self.disposeBag)
    }
}

extension LoginVc : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let image = CommonComponentFactory.buildLogo()
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.center.equalToSuperview()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(40)
            make.bottom.equalToSuperview()
        }
        
        let containerScheme = MDCContainerScheme()
        let btnLogin = MDCButton()
        btnLogin.applyTextTheme(withScheme: containerScheme)
        btnLogin.setTitle("Login", for: .normal)
        stackView.addArrangedSubview(btnLogin)
        btnLogin.addTarget(self, action: #selector(onLogin), for: .touchDown)
        
        let btnFingerprint = MDCButton()
        btnFingerprint.applyContainedTheme(withScheme: containerScheme)
        btnFingerprint.setTitle("Login With Finger", for: .normal)
        btnFingerprint.addTarget(self, action: #selector(onBioLogin), for: .touchDown)
        stackView.addArrangedSubview(btnFingerprint)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell-login-input", for: indexPath) as? LoginInputCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            self.inputPhoneNumber = "081311137368"
            cell.delegate = { text in
                self.inputPhoneNumber = text
            }
            cell.input.text = self.inputPhoneNumber
        } else {
            self.inputPin = "123456"
            cell.delegate = { text in
                self.inputPin = text
            }
            cell.input.text = self.inputPin
            cell.input.isSecureTextEntry = true
            cell.input.label.text = "Password / PIN"
            cell.input.placeholder = "Input Password"
        }
        
        return cell
    }
    
    @objc func onLogin(_ sender: UIView) {
        self.showWait()
        self.viewModel.doLogin(self.inputPhoneNumber, pin: self.inputPin)
    }
    
    @objc func onBioLogin(_ sender: UIView) {
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                if success {
                    print("---> success")
                    DispatchQueue.main.sync {
                        self.showWait()
                    }
                    
                    self.viewModel.doBioLogin(self.inputPhoneNumber)
                } else {
                    print("---> failed")
                }
            }
        } else {
            let alert = CommonComponentFactory.buildAlert("Biometric is not setup yet.")
            self.present(alert, animated: true)
        }
        
    }
}


