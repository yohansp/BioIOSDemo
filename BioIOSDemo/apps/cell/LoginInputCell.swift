//
//  LoginInputCell.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 21/02/24.
//

import Foundation
import UIKit
import MaterialComponents

class LoginInputCell: UITableViewCell {
    
    var delegate: ((String) -> Void)?
    
    lazy var input: MDCOutlinedTextField = {
        let input = MDCOutlinedTextField()
        input.keyboardType = .phonePad
        input.placeholder = "Input Phone Number"
        input.label.text = "Phone Number"
        return input
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(input)
        input.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        input.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0))
        }
    }
    
    @objc func onTextChange(_ sender: UITextField) {
        self.delegate?(sender.text ?? "")
    }
}
