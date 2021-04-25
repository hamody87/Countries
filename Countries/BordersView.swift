//
//  BordersView.swift
//  Countries
//
//  Created by Muhammad Jbara on 22/04/2021.
//

import UIKit

extension BordersView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

}

extension BordersView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView: UIView = UIView(frame: CGRect( x: 0, y: 0, width: self.tableView.frame.width, height: 40.0))
        sectionView.backgroundColor =  UIColor(rgb: 0xe9e9e9)
        let title: UILabel = UILabel(frame: sectionView.bounds)
        title.textColor = .black
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 16.0)
        sectionView.addSubview(title)
        if section == 0 {
            title.text = "Country"
        } else {
            title.text = "Borders"
        }
        return sectionView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.borders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseId", for: indexPath)
        let name: UILabel!
        let nativeName: UILabel!
        if let label: UILabel = cell.viewWithTag(111) as? UILabel {
            name = label
        } else {
            name = UILabel(frame: CGRect(x: 0, y: 10.0, width: cell.frame.width, height: 30.0))
            name.textColor = UIColor(named: "Font/Second")
            name.textAlignment = .center
            name.font = UIFont.boldSystemFont(ofSize: 16.0)
            name.tag = 111
            name.numberOfLines = 0
            cell.addSubview(name)
        }
        if let label: UILabel = cell.viewWithTag(222) as? UILabel {
            nativeName = label
        } else {
            nativeName = UILabel(frame: CGRect(x: 0, y: 40.0, width: cell.frame.width, height: 30.0))
            nativeName.textColor = UIColor(named: "Font/Second")
            nativeName.textAlignment = .center
            nativeName.font = UIFont.systemFont(ofSize: 15.0)
            nativeName.tag = 222
            nativeName.numberOfLines = 0
            cell.addSubview(nativeName)
        }
        name.text = "..."
        nativeName.text = "..."
        if indexPath.section == 0 {
            if let nameText = self.selectItem["name"] as? String, let nativeNameText = self.selectItem["nativeName"] as? String {
                name.text = nameText
                nativeName.text = nativeNameText
            }
        } else {
            if let item = self.borders[indexPath.row] as? [String: Any], let nameText = item["name"] as? String, let nativeNameText = item["nativeName"] as? String {
                name.text = nameText
                nativeName.text = nativeNameText
            }
        }
        return cell
    }
    
}

class BordersView: UIViewController {
    
    // MARK: - Declare Basic Variables
    
    private var tableView: UITableView!
    var selectItem: [String: Any]!
    var borders: [Any] = [Any]()
    
    // MARK: - private Methods
    
    private func loadBordersCountry() {
        if let borders = self.selectItem["borders"] as? [String] {
            print("https://restcountries.eu/rest/v2/alpha?codes=\(borders.joined(separator: ";"))")
            RequestJSON().request (withUrl: "https://restcountries.eu/rest/v2/alpha?codes=\(borders.joined(separator: ";"))") { (data) in
                do {
                    if let data = data, let items = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        self.borders = items
                        self.tableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.loadBordersCountry()
                    }
                }
            } failureBlock: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.loadBordersCountry()
                }
            }
        }
    }
    
    // MARK: - Interstitial BordersView
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadBordersCountry()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Country Borders"
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self as UITableViewDataSource
        self.tableView.delegate = self as UITableViewDelegate
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cellReuseId")
        self.view.addSubview(self.tableView)
    }
    
}
