//
//  SearchViewController.swift
//  ShowerSong
//
//  Created by Alexandre Ménielle on 30/06/2018.
//  Copyright © 2018 Alexandre Ménielle. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var session: SPTSession?
    var playlistId = ""
    
    var tracks : [Track] = []
    var albumImages : [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchOnSpotify(text : String){
        guard let session = self.session else { return }
        let url = "https://api.spotify.com/v1/search?q=\(text)&type=track"
        let headers : HTTPHeaders  = ["Authorization":"Bearer " + session.accessToken]
        activityIndicator.startAnimating()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) in
                
                self.albumImages.removeAll()
                self.tracks.removeAll()
                if let json = response.result.value as? [String:Any],
                    let tracks = json["tracks"] as? [String:Any],
                    let items = tracks["items"] as? [NSDictionary]{
                    for item in items{
                        if let track = Track(dictionary: item){
                            self.tracks.append(track)
                            self.albumImages.append(UIImageView(image: #imageLiteral(resourceName: "music_placeholder2")))
                        }
                    }
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.setImages()
                }
            })
    }
    
    func setImages(){
        for i in 0..<tracks.count{
            if let imageUrl = tracks[i].album?.images?.first?.url {
                self.albumImages[i].downloadedFrom(link: imageUrl, contentMode: .scaleAspectFit, tableview: tableView)
            }
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : PlaylistCell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as? PlaylistCell,
        indexPath.row < tracks.count
            else { return UITableViewCell() }
        
        
        let track = tracks[indexPath.row]

        cell.titleLabel.text = track.name ?? ""
        
        var artistsName = ""
        
        if let artists = track.artists{
            for artist in artists{
                artistsName += artist.name ?? ""
                artistsName += ", "
            }
        }
        
        let endIndex = artistsName.index(artistsName.endIndex, offsetBy: -2)
        cell.artistLabel.text = artistsName.substring(to: endIndex)
        
        if let duration = track.duration_ms{
            let sec = duration / 1000
            let min = sec / 60
            let secRest = sec - (min * 60)
            cell.timeLabel.text = "\(min):\(secRest)"
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = cell.backgroundColor2
        }else{
            cell.backgroundColor = cell.backgroundColor1
        }
        
        cell.trackImage.image = albumImages[indexPath.row].image
        cell.trackImage.layer.cornerRadius = cell.trackImage.frame.width / 2
        cell.trackImage.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = "https://api.spotify.com/v1/users/\(session?.canonicalUsername ?? "")/playlists/\(playlistId)/tracks"
        let track = tracks[indexPath.row]
        let parameters : Parameters = ["uris": ["spotify:track:\(track.id ?? "")"]]
        
        guard let session = self.session else { return }
        let headers : HTTPHeaders  = ["Authorization":"Bearer " + session.accessToken]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) in
                
                print("Tracks added")
        })
        
        self.searchBar.text = ""
        self.albumImages.removeAll()
        self.tracks.removeAll()
        tableView.reloadData()
        showToast(message: "Musique ajoutée")
    }
    
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var text = ""
        for char in searchText{
            if(char == " "){
                text += "%20"
            }else{
                text += "\(char)"
            }
        }
        if(text == ""){
            self.albumImages.removeAll()
            self.tracks.removeAll()
            tableView.reloadData()
        }else{
            searchOnSpotify(text: text)
        }
    }
}

extension UIViewController{
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height/2, width: 200, height: 35))
        
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.font = UIFont(name: "AvenirLTStd-Light", size: 15.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
