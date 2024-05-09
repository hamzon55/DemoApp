//
//  ViewController.swift
//  DemoApp
//
//  Created by HamZa Jerbi on 5/5/24.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    private lazy var tableView: UITableView = {
          let tableView = UITableView(frame: view.bounds, style: .plain)
          tableView.delegate = self
          tableView.dataSource = self
          return tableView
      }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        view.addSubview(tableView)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // Return the number of rows in your table
           return 10
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // Dequeue or create a new cell
           let cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
           
           // Configure the cell
           cell.textLabel?.text = "Row \(indexPath.row)"
           
           return cell
       }

       // MARK: - UITableViewDelegate methods
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // Handle row selection
           print("Selected row \(indexPath.row)")
       }
    

}
