//
//  TableViewController.swift
//  StormViewer
//
//  Created by Matt X on 11/1/22.
//

import UIKit

class TableViewController: UITableViewController {
    var pictures: [String] = []
    var pictureShownCounts: [String:Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // This is a picture to load...
                pictures.append(item)
            }
        }
        
        pictures.sort()
        
        // Load saved picture counts...
        if let savedCounts = UserDefaults.standard.data(forKey: "pictureShownCounts") {
            do {
                pictureShownCounts = try JSONDecoder().decode([String:Int].self, from: savedCounts)
            } catch {
                print("Failed to load picture view counts.")
            }
        } else {
            // Does not exist already...
            for picture in pictures {
                pictureShownCounts.updateValue(0, forKey: picture)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pictureName = pictures[indexPath.row]
        guard let pictureShownCount = pictureShownCounts[pictureName] else {
            fatalError("Cannot get picture view count for \(pictureName).")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictureName
        cell.detailTextLabel?.text = "Times shown: \(pictureShownCount)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pictureName = pictures[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictureName
            vc.titleString = "Picture \(indexPath.row + 1) of \(pictures.count)"
            
            if pictureShownCounts.keys.contains(pictureName) {
                let currViewCount = pictureShownCounts[pictureName]!
                pictureShownCounts.updateValue(currViewCount + 1, forKey: pictureName)
                
                save()
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        if let savedData = try? JSONEncoder().encode(pictureShownCounts) {
            UserDefaults.standard.set(savedData, forKey: "pictureShownCounts")
        }
        
        tableView.reloadData()
    }
}

