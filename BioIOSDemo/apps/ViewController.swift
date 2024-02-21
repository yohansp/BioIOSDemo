//
//  LoginVc.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 20/02/24.
//

import UIKit
import MaterialComponents
import LocalAuthentication

class ViewController: BaseVc {
    
    private let viewModel: BioViewModel = BioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let guideLineMiddle = UIView()
        view.addSubview(guideLineMiddle)
        guideLineMiddle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let label2 = UILabel()
        label2.textAlignment = .center
        label2.text = "iOS Developer"
        label2.textColor = .black
        label2.font = UIFont.systemFont(ofSize: 19)
        view.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(guideLineMiddle.snp.top)
        }
        
        let label1 = UILabel()
        label1.textAlignment = .center
        label1.text = "Welcome Home"
        label1.textColor = .black
        label1.font = UIFont.systemFont(ofSize: 25)
        view.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(label2.snp.top).offset(-16)
        }
        
        let logo = CommonComponentFactory.buildLogo()
        view.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(label1.snp.top).offset(-70)
        }
        
        // button menu
        let containerScheme = MDCContainerScheme()
        let btnSharedKey = MDCButton()
        btnSharedKey.applyContainedTheme(withScheme: containerScheme)
        btnSharedKey.setTitle("Setup", for: .normal)
        btnSharedKey.addTarget(self, action: #selector(onGetSharedKey), for: .touchUpInside)
        view.addSubview(btnSharedKey)
        btnSharedKey.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(guideLineMiddle.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        
        let btnLogout = MDCButton()
        btnLogout.applyTextTheme(withScheme: containerScheme)
        btnLogout.setTitle("Logout", for: .normal)
        btnLogout.addTarget(self, action: #selector(onLogout), for: .touchUpInside)
        view.addSubview(btnLogout)
        btnLogout.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(btnSharedKey.snp.bottom).offset(9)
            make.height.equalTo(50)
        }
        
        // observer
        viewModel.liveHandleSharedKey.subscribe(onNext: { data in
            self.hideWait()
            let alert = CommonComponentFactory.buildAlert("Biometric active.")
            self.present(alert, animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    @objc func onLogout(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func onGetSharedKey(_ sender: UIButton) {
        self.setupBiometric()
    }
    
    func setupBiometric() {
        var authError: NSError?
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            self.showWait()
            self.viewModel.doGetSharedKey("123456")
        } else {
            let alert = CommonComponentFactory.buildAlert("Biometric is not setup yet.")
            self.present(alert, animated: true)
        }
    }
}
