//
//  ViewController.swift
//  SCRRefreshControl
//
//  Created by Stephen Cao on 3/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = SCRRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        loadData()
    }
    @objc private func loadData(){
        refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            self.refreshControl.endRefreshing()
        }
    }
}

