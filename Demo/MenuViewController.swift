//
//  MenuViewController.swift
//  Demo
//
//  Created by Kei Fujikawa on 2018/12/10.
//  Copyright © 2018 kboy. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    let menu: [String] = ["Demo1", "Demo2"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    private func goDemo1(){
        let sb = UIStoryboard(name: "Demo1", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    private func goDemo2(){
        let sb = UIStoryboard(name: "Demo2", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        present(vc, animated: true, completion: nil)
    }
    
}

extension MenuViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = menu[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            goDemo1()
        default:
            goDemo2()
        }
    }
}
