//
//  ViewController.swift
//  Countries
//
//  Created by Muhammad Jbara on 22/04/2021.
//

import UIKit

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseId", for: indexPath)
        let name: UILabel!
        let nativeName: UILabel!
        let btnCell: UIButton!
        if let label: UILabel = cell.viewWithTag(111) as? UILabel {
            name = label
        } else {
            name = UILabel(frame: CGRect(x: 0, y: 10.0, width: cell.frame.width, height: 30.0))
            name.textColor = .black
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
            name.textColor = .black
            nativeName.textAlignment = .center
            nativeName.font = UIFont.systemFont(ofSize: 15.0)
            nativeName.tag = 222
            nativeName.numberOfLines = 0
            cell.addSubview(nativeName)
        }
        if let btn: UIButton = cell.viewWithTag(333) as? UIButton {
            btnCell = btn
        } else {
            btnCell = UIButton(frame: cell.bounds)
            btnCell.addTarget(self, action: #selector(self.presentBordersView(_ :)), for: .touchUpInside)
            cell.addSubview(btnCell)
        }
        name.text = "..."
        nativeName.text = "..."
        btnCell.tag = indexPath.row
        if let item = self.sortedItems[indexPath.row] as? [String: Any], let nameText = item["name"] as? String, let nativeNameText = item["nativeName"] as? String {
            name.text = nameText
            nativeName.text = nativeNameText
        }
        return cell
    }
    
}

extension ViewController: ContentHearderViewDelegate {
    
    func sortNameValueDictionary() {
        if let _ = self.items {
            self.sortedItems = (self.items as NSArray).sortedArray(using: [NSSortDescriptor(key: "name", ascending: self.headerView.namesIsiAscending)])
            self.tableView.reloadData()
        }
    }
    
    func sortAreaValueDictionary() {
        if let _ = self.items {
            self.sortedItems = (self.items as NSArray).sortedArray(using: [NSSortDescriptor(key: "area", ascending: self.headerView.areaIsiAscending)])
            self.tableView.reloadData()
        }
    }
}

class ViewController: UIViewController {
    
    private var tableView: UITableView!
    private var items: [Any]!
    private var sortedItems: [Any] = [Any]()
    private var count: Int = 0
    private var headerView: ContentHearderView!
    
    // MARK: - private Methods
    
    @objc private func presentBordersView(_ sender: UIButton) {
        if let item = self.sortedItems[sender.tag] as? [String: Any] {
            let bordersView: BordersView = BordersView()
            bordersView.selectItem = item
            self.navigationController?.pushViewController(bordersView, animated: true)
        }
        
    }
    
    private func safeArea() -> UIEdgeInsets {
        let window = UIApplication.shared.windows[0]
        return window.safeAreaInsets
    }
    
    private func loadItems() {
        RequestJSON().request (withUrl: "https://restcountries.eu/rest/v2/all") { (data) in
            do {
                if let data = data, let items = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    self.items = items
                    self.headerView.firstLoad()
                }
            } catch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.loadItems()
                }
            }
        } failureBlock: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.loadItems()
            }
        }
    }
    
    // MARK: - Interstitial ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries List"
        self.view.backgroundColor = .white
        self.navigationItem.backButtonTitle = "Back"
        self.headerView = ContentHearderView(withFrame: CGRect(x: 0, y: (self.navigationController?.toolbar.frame.height ?? 0) + self.safeArea().top - 4.0, width: self.view.frame.width, height: 60.0), delegate: self)
        self.view.addSubview(self.headerView)
        self.tableView = UITableView(frame: CGRect(x: 0, y: self.headerView.frame.origin.y + self.headerView.frame.height, width: self.view.frame.width, height: self.view.frame.height - self.headerView.frame.origin.y - self.headerView.frame.height))
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self as UITableViewDataSource
        self.tableView.delegate = self as UITableViewDelegate
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cellReuseId")
        self.view.addSubview(self.tableView)
        self.loadItems()
    }
    
}

