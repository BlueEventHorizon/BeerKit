//
//  ViewController.swift
//  Example
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import UIKit
import BeerKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    var messages: [MessageEntity] = []
    var beerKit: NearPeer = NearPeer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        beerKit.start(serviceType: "BeerDemo", displayName: UIDevice.current.name)
        
        beerKit.onConnect { peerId in
            DispatchQueue.main.async {
                self.deviceNameLabel.text = peerId.displayName
            }
        }
    
        beerKit.onRecieved { (peerId, data) in
            
            guard let data = data else { return }
            
            if let decoded = try? JSONDecoder().decode(EventEntity.self, from: data) {
                
                guard let data = decoded.data, let message = try? JSONDecoder().decode(MessageEntity.self, from: data) else {
                    return
                }
    
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func sayHiButtonTapped(_ sender: Any) {
        let message = MessageEntity(name: UIDevice.current.name, message: "Oh my God!")
        let data: Data = try! JSONEncoder().encode(message)
        let entity = EventEntity(event: "message", data: data)
        let encoded: Data = try! JSONEncoder().encode(entity)
        beerKit.sendData(encoded)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = messages[indexPath.row].name
        cell.detailTextLabel?.text = messages[indexPath.row].message
        return cell
    }
}

