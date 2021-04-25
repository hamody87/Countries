//
//  ContentHearderView.swift
//  Countries
//
//  Created by Muhammad Jbara on 25/04/2021.
//

import UIKit

@objc protocol ContentHearderViewDelegate {
    func sortNameValueDictionary()
    func sortAreaValueDictionary()
}

class ContentHearderView: UIView {
    
    // MARK: - Declare Basic Variables
    
    var nameView: UIView!
    var areaView: UIView!
    var nameIcon: UIImageView!
    var areaIcon: UIImageView!
    
    private var namesIsOn: Bool = false
    private var areaIsOn: Bool = false
    var namesIsiAscending: Bool = true
    var areaIsiAscending: Bool = true
    private var ascendingImage: UIImage! {
        if let icon: UIImage = UIImage(named: "AscendingIcon") {
            return icon
        }
        return nil
    }
    private var descendingImage: UIImage! {
        if let icon: UIImage = UIImage(named: "DescendingIcon") {
            return icon
        }
        return nil
    }
    weak private var _delegate: ContentHearderViewDelegate? = nil
    weak var delegate: ContentHearderViewDelegate? {
        set(delegateValue) {
            self._delegate = delegateValue
        }
        get {
            return self._delegate
        }
    }
    
    
    // MARK: - Public Methods
    
    public func firstLoad() {
        self.switchNameViewToOn()
    }
    
    // MARK: - private Methods
    
    private func setIcons() {
        if self.namesIsiAscending {
            self.nameIcon.image = self.ascendingImage
        } else {
            self.nameIcon.image = self.descendingImage
        }
        if self.areaIsiAscending {
            self.areaIcon.image = self.ascendingImage
        } else {
            self.areaIcon.image = self.descendingImage
        }
    }
    
    @objc private func switchNameViewToOn() {
        if !self.namesIsOn {
            self.namesIsiAscending = !self.namesIsiAscending
        }
        self.namesIsOn = true
        self.areaIsOn = false
        self.namesIsiAscending = !self.namesIsiAscending
        self.nameView.backgroundColor = .white
        self.areaView.backgroundColor = .clear
        self.setIcons()
        self.delegate?.sortNameValueDictionary()
    }
    
    @objc private func switchAreaViewToOn() {
        if !self.areaIsOn {
            self.areaIsiAscending = !self.areaIsiAscending
        }
        self.namesIsOn = false
        self.areaIsOn = true
        self.areaIsiAscending = !self.areaIsiAscending
        self.nameView.backgroundColor = .clear
        self.areaView.backgroundColor = .white
        self.setIcons()
        self.delegate?.sortAreaValueDictionary()
    }
    
    // MARK: - Interstitial ContentHearderView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: ContentHearderViewDelegate?) {
        super.init(frame: frame)
        self.delegate = delegate
        self.backgroundColor =  UIColor(rgb: 0xe9e9e9)
        self.nameView = UIView(frame: CGRect(x: 10.0, y: 10.0, width: (frame.width - 30.0) / 2.0, height: frame.height - 20.0))
        self.addSubview(self.nameView)
        self.nameIcon = UIImageView(frame: CGRect(x: 10.0, y: (self.nameView.frame.height - self.ascendingImage.size.height) / 2.0, width: self.ascendingImage.size.width, height: self.ascendingImage.size.height))
        self.nameView.addSubview(self.nameIcon)
        let nameLabel: UILabel = UILabel(frame: self.nameView.bounds)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        nameLabel.text = "Countries Name"
        nameLabel.textAlignment = .center
        self.nameView.addSubview(nameLabel)
        let nameViewBtn: UIButton = UIButton(frame: nameView.bounds)
        nameViewBtn.addTarget(self, action: #selector(self.switchNameViewToOn), for: .touchUpInside)
        self.nameView.addSubview(nameViewBtn)
        self.areaView = UIView(frame: CGRect(origin: CGPoint(x: self.nameView.frame.origin.x + self.nameView.frame.width + 10.0, y: 10.0), size: self.nameView.frame.size))
        self.addSubview(self.areaView)
        self.areaIcon = UIImageView(frame: CGRect(x: 10.0, y: (self.areaView.frame.height - self.ascendingImage.size.height) / 2.0, width: self.ascendingImage.size.width, height: self.ascendingImage.size.height))
        self.areaView.addSubview(self.areaIcon)
        let areaLabel: UILabel = UILabel(frame: self.areaView.bounds)
        areaLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        areaLabel.text = "Area"
        areaLabel.textAlignment = .center
        self.areaView.addSubview(areaLabel)
        let areaViewBtn: UIButton = UIButton(frame: nameView.bounds)
        areaViewBtn.addTarget(self, action: #selector(self.switchAreaViewToOn), for: .touchUpInside)
        self.areaView.addSubview(areaViewBtn)
    }
    
}
