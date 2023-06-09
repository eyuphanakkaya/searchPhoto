//
//  CollectionViewCell.swift
//  searchPhoto
//
//  Created by Eyüphan Akkaya on 9.06.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gelenUrl: UIImageView!
    
    
    func config(with urlString:String)  {
        guard let url = URL(string: urlString) else {
            return
        }
       URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            if error != nil || data == nil {
                print("error")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self!.gelenUrl.image = image
            }
       }.resume()
    }
}
    

