//
//  ViewController.swift
//  searchPhoto
//
//  Created by Eyüphan Akkaya on 9.06.2023.
//

import UIKit

struct Photo: Codable {
    let total:Int
    let total_pages:Int
    let results:[Result]
    
}
struct Result: Codable {
    let id:String
    let urls:Urls
}
struct Urls: Codable {
    let regular:String
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var results = [Result]()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
      collectionView.delegate = self
      collectionView.dataSource = self
      searchBar.delegate = self

        let tasarim = UICollectionViewFlowLayout()
        collectionView.frame = .zero
        tasarim.itemSize = CGSize(width: view.frame.width/3, height: view.frame.height/3)
        tasarim.minimumInteritemSpacing = 0
        tasarim.minimumLineSpacing = 0
       

        collectionView.collectionViewLayout = tasarim

        

    }


    func fetchRequest(ara:String){
        let urlSession = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(ara)&client_id=9j8YXwB7dLMz41Fddv73NycLqWZ6lrY_it6wKxtEoS4"
        let url = URL(string: urlSession)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("error")
                return
            }
            do {
                let request = try JSONDecoder().decode(Photo.self, from: data!)
                DispatchQueue.main.async {
                    self.results = request.results
                    self.collectionView.reloadData()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrlString = results[indexPath.row].urls.regular
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        cell?.config(with: imageUrlString)
        return cell!
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            results = []
            collectionView.reloadData()
            print(text)
            fetchRequest(ara: text)
        }
    }

}

