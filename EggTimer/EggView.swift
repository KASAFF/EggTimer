//
//  EggView.swift
//  EggTimer
//
//  Created by Aleksey Kosov on 25.01.2023.
//

import UIKit

class EggView: UIView {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
        let eggImageView: UIImageView = {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFit
            return iv
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        
        
    }
    
    convenience init(target: Any, selector: Selector, imageName: String, title: String) {
        self.init(frame: .zero)
        button.addTarget(target, action: selector, for: .touchUpInside)
        eggImageView.image = UIImage(named: imageName)
        button.isUserInteractionEnabled = true
        button.setTitle(title, for: .normal)

        configureUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureUI() {
        addSubview(eggImageView)
        addSubview(button)

        [eggImageView, button].forEach { view in
            view.isUserInteractionEnabled = true
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor),
                view.heightAnchor.constraint(equalToConstant: 200),
                view.widthAnchor.constraint(equalToConstant: 100),
            ])
        }
    }
}
