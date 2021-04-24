//
//  ViewController.swift
//  Countries
//
//  Created by Muhammad Jbara on 22/04/2021.
//

import UIKit

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedItems.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! HeaderView
        if headerView.content == nil {
            let sortView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50.0))
            sortView.backgroundColor = UIColor(rgb: 0xe9e9e9)
            headerView.content = sortView
            print("ssss \(section)")
        }
         return headerView
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
        if let item = self.sortedItems[indexPath.row] as? [String: Any], let nameText = item["name"] as? String, let nativeNameText = item["nativeName"] as? String {
            name.text = nameText
            nativeName.text = nativeNameText
        }
        return cell
    }
    
}

class ViewController: UIViewController {
    
    private var tableView: UITableView!
    private var items: [Any]!
    private var sortedItems: [Any] = [Any]()
    private var count: Int = 0
    
    private func sortedByNameValueDictionary(_ ascending: Bool) {
        self.sortedItems = (items as NSArray).sortedArray(using: [NSSortDescriptor(key: "name", ascending: ascending)])
        self.tableView.reloadData()
    }
    
    private func sortedByAreaValueDictionary(_ ascending: Bool) {
        self.sortedItems = (items as NSArray).sortedArray(using: [NSSortDescriptor(key: "area", ascending: ascending)])
        self.tableView.reloadData()

    }
    
    private func loadItems() {
        RequestJSON().request (withUrl: "https://restcountries.eu/rest/v2/all") { (data) in
            do {
                if let data = data, let items = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    self.items = items
                    self.sortedByAreaValueDictionary(false)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries List"
        self.navigationItem.backButtonTitle = "Back"
//        let sortView: UIView = UIView(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.height ?? 0, width: self.view.frame.width, height: 60.0))
//        sortView.backgroundColor = UIColor(rgb: 0x000000)
//        self.view.addSubview(sortView)
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self as UITableViewDataSource
        self.tableView.delegate = self as UITableViewDelegate
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cellReuseId")
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "CustomHeader")
        self.view.addSubview(self.tableView)
        self.loadItems()
    }
    
}

