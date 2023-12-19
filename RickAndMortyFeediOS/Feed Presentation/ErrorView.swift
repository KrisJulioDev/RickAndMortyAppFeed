//
//  ErrorView.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/13/23.
//

import UIKit

public class ErrorView: UIButton {
    public var onHide: (() -> Void)?
    public var message: String? {
        get { isVisible ? title(for: .normal) : nil }
        set { setMessageAnimated(newValue) }
    }
    
    private var isVisible: Bool {
        alpha > 0
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        backgroundColor = .errorBackgroundColor
        
        addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
        configureLabel()
        hideMessage()
    }
    
    private func configureLabel() {
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        titleLabel?.font = .preferredFont(forTextStyle: .body)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    private func setMessageAnimated(_ title: String?) {
        if let title {
            animate(display: title)
        } else {
            hideMessageAnimated()
        }
    }
        
    private func animate(display title: String?) {
        setTitle(title, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
         
        UIView.animate(withDuration: 0.25) { self.alpha = 1 }
    }
    
    @objc private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.hideMessage() }
            })
    }
    
    private func hideMessage() {
        setTitle(nil, for: .normal)
        alpha = 0
        contentEdgeInsets = .init(top: -2.5, left: 0, bottom: -2.5, right: 0)
        onHide?()
    }
}

extension UIColor {
    static var errorBackgroundColor: UIColor {
        UIColor(red: 0.99951404330000004, green: 0.41759261489999999, blue: 0.4154433012, alpha: 1)
    }
}
