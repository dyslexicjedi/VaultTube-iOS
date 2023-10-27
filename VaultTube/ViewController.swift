//
//  ViewController.swift
//  Test2
//
//  Created by Robert Clowser on 10/27/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var unwatchedData = [Card]()
    
    func fetchAPIData(URL url:String,completion: @escaping ([Card]) -> Void) {
        
        let url = URL(string: url)
        guard url != nil else{
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            //Check for Errro
            if error == nil && data != nil{
                //Parse JSON
                let decoder = JSONDecoder()
                do {
                    let unwatched = try decoder.decode([Card].self, from: data!)
                    //self.unwatchedData = unwatched
                    completion(unwatched)
                    //print(unwatched)
                }
                catch{
                    print("Error in JSON Parsing")
                }
            }
        }
        //Go
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "http://10.0.10.12:5000/api/unwatched/PublishedAt/0"
        tableView.delegate = self
        tableView.dataSource = self
        fetchAPIData(URL: urlString){ result in
            self.unwatchedData = result
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }

    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unwatchedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryCard
        cell.label.text = unwatchedData[indexPath.row].title
        cell.iconImageView.imageFromURL(urlString: "http://10.0.10.12:5000/api/images/"+unwatchedData[indexPath.row].id, PlaceHolderImage: UIImage.init(named: "test")!)
        return cell
    }
    
    func getImage(URL url:String) -> UIImage?{
        let url = URL(string: url)
        let data = try? Data(contentsOf:  url!)
        return UIImage(data: data!)

    }
}

extension UIImageView{
    public func imageFromURL(urlString: String, PlaceHolderImage:UIImage){
        if self.image == nil{
            self.image = PlaceHolderImage
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL,completionHandler: { (data,response,error) -> Void in
            if error != nil{
                print("Error")
            }
            DispatchQueue.main.async(execute: {() -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}
