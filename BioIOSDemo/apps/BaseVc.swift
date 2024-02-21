//
//  BaseVc.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 21/02/24.
//

import UIKit
import RxSwift

class BaseVc: UIViewController {
    private var _disposeBag: DisposeBag?
    var disposeBag: DisposeBag {
        get {
            if let d = self._disposeBag {
                return d
            } else {
                self._disposeBag = DisposeBag()
                return self._disposeBag!
            }
        }
    }
    
    lazy var viewWait: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.cornerRadius = 19
        return view
    }()
    
    lazy var wait: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()
    
    func showWait() {
        view.addSubview(viewWait)
        viewWait.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        
        viewWait.addSubview(wait)
        wait.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(70)
        }
        wait.startAnimating()
    }
    
    func hideWait() {
        wait.stopAnimating()
        wait.removeFromSuperview()
        viewWait.removeFromSuperview()
    }
}
