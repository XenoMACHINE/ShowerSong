//
//  ViewController.swift
//  ShowerSong
//
//  Created by Alexandre Ménielle on 20/03/2018.
//  Copyright © 2018 Alexandre Ménielle. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation
import CocoaMQTT
import MediaPlayer
import AVKit
import Alamofire

class ViewController: UIViewController {
 
    @IBOutlet weak var connectedView: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playButtons: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var boxConnected = false
    var albumImages : [UIImageView] = []
    var tracks : [Track] = []
    var isMqttConnected = false
    
    // Variables
    var lastMqttMessage = ""
    var canExecCommands = true
    var auth = SPTAuth.defaultInstance()!
    var needWait = false
    
    // Initialzed in either updateAfterFirstLogin: (if first time login) or in viewDidLoad (when there is a check for a session object in User Defaults
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    var session: SPTSession?
    
    var playlistShowerUri : URL?
    var mqtt : CocoaMQTT!
    var currentHour = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        if let sessionObj:AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject?,
            let sessionDataObj = sessionObj as? Data,
            let session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession{

            self.session = session
            if session.isValid(){
                self.activityIndicator.startAnimating()
                self.loginButton.isHidden = true
                self.titleView.isHidden = false
                initializaPlayer(authSession: session)
            }
            /*else{
                self.setup()
                let refreshURL = "ShowerSong://refreshURL" // put your redirect URL here
                let swapURL = "ShowerSong://swapURL" // put your redirect URL here
                auth.tokenRefreshURL = URL(string: refreshURL)
                auth.tokenSwapURL    = URL(string: swapURL)
                auth.renewSession(session, callback: { (error, renewSession) in
                    if let newSession = renewSession{
                        self.initializaPlayer(authSession: newSession)
                        let sessionData = NSKeyedArchiver.archivedData(withRootObject: newSession)
                        UserDefaults.standard.set(sessionData, forKey: "SpotifySession")
                    }else{
                        self.activityIndicator.stopAnimating()
                        self.loginButton.isHidden = false
                    }
                })
            }*/
        }
        
        setupMqtt()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clockManager(){
        //tmp pr test (push tte les Xsec)
        /*Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HHmm"
            let hour = dateFormatter.string(from: Date())
            self.currentHour = hour
            self.mqtt.publish("showerSong/clock/", withString: self.currentHour)
        }*/
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HHmm"
            let hour = dateFormatter.string(from: Date())
            if self.currentHour != hour {
                self.currentHour = hour
                self.mqtt.publish("showerSong/clock/", withString: self.currentHour)
                print(hour)
            }
        }
    }
    
    func setupMqtt(){
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        self.mqtt = CocoaMQTT(clientID: clientID, host: "vps363392.ovh.net", port: 8080)
        self.mqtt.delegate = self
        print(mqtt.clientID)
        self.mqtt.disconnect()
        self.mqtt.connect()
        //mqtt.subscribe("showerShong/")
        launchTimerMqtt()
    }
    
    func launchTimerMqtt(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if self.isMqttConnected{
                timer.invalidate()
                return
            }
            self.mqtt.disconnect()
            self.mqtt.connect()
        }
    }
    
    func updateAfterFirstLogin () {
        
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject?,
            let sessionDataObj = sessionObj as? Data,
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession{
            self.session = firstTimeSession
            initializaPlayer(authSession: firstTimeSession)
        }
        
    }
    
    func initializaPlayer(authSession:SPTSession){
        if self.player == nil {
            
            self.player = SPTAudioStreamingController.sharedInstance()
            if let player = self.player {
                player.playbackDelegate = self
                player.delegate = self
                try? player.start(withClientId: auth.clientID)
                player.login(withAccessToken: authSession.accessToken)
                //getUserPlaylists() call in delegate
            }
        }
    }

    func setup() {
        // insert redirect your url and client ID below
        let redirectURL = "ShowerSong://returnAfterLogin" // put your redirect URL here
        let clientID = "36c5e0558e0545bd93592e79f1c32e02" // put your client ID here
        auth.redirectURL     = URL(string: redirectURL)
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthUserReadTopScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserReadPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    func getUserPlaylists(){
        guard let session = self.session else { return }
        SPTPlaylistList.playlists(forUser: session.canonicalUsername, withAccessToken: session.accessToken, callback: { (error, response) in
            //pb ici
            if error != nil {
                print(error!)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.getUserPlaylists()
                }
                return
            }
            self.activityIndicator.stopAnimating()
            if let listPage = response as? SPTPlaylistList, let playlists = listPage.items as? [SPTPartialPlaylist] {
                for playlist in playlists {
                    if playlist.name.lowercased().contains("shower") {
                        self.playlistShowerUri = playlist.uri
                        self.getPlaylistFromApi()
                    }
                }
            }
        })
        
    }
    
    func getPlaylistId() -> String{
        var result = ""
        
        for char in playlistShowerUri?.absoluteString.reversed() ?? []{
            if char == ":"{
                break
            }
            result = "\(char)\(result)"
        }
        
        return result
    }
    
    func getPlaylistFromApi(){
        guard let session = self.session else { return }
        let url = "https://api.spotify.com/v1/users/\(session.canonicalUsername ?? "")/playlists/" + getPlaylistId()
        let headers : HTTPHeaders  = ["Authorization":"Bearer " + session.accessToken]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) in
                
                if let json = response.result.value as? [String:Any],
                let tracks = json["tracks"] as? [String:Any],
                let items = tracks["items"] as? [[String:Any]]{
                    print(items)
                    for item in items{
                        if let trackDic = item["track"] as? NSDictionary{
                            if let track = Track(dictionary: trackDic){
                                self.tracks.append(track)
                                self.albumImages.append(UIImageView(image: #imageLiteral(resourceName: "music_placeholder2")))
                            }
                        }
                    }
                    self.tableView.reloadData()
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
    
    func execPlayPause(sender : UIButton){
        guard
            let player = self.player,
            let playlistURL = self.playlistShowerUri else { return }
        if sender.tag == 0 {
            if player.playbackState != nil {
                player.setIsPlaying(true, callback: { (error) in
                    if let error = error{
                        print(error)
                    }
                    sender.tag = 1
                    sender.setTitle("Pause", for: .normal)
                })
            }else{
                player.playSpotifyURI(playlistURL.absoluteString, startingWith: 0, startingWithPosition: 0, callback: { (error) in
                    if let error = error{
                        print(error)
                    }else{
                        sender.tag = 1
                        sender.setTitle("Pause", for: .normal)
                    }
                })
            }
        }else {
            //try? player.stop()
            
            player.setIsPlaying(false, callback: nil)
            sender.tag = 0
            sender.setTitle("Play", for: .normal)
        }
    }
    
    func execNext(){
        guard let player = self.player else { return }
        player.skipNext(nil)
    }
    
    func execPrevious(){
        guard let player = self.player else { return }
        player.skipPrevious(nil)
    }
    
    func execVolumeLess() {
        let  audioSession = AVAudioSession.sharedInstance()
        var volume : Float = audioSession.outputVolume
        volume -= 0.05
        print(volume)
        (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(volume, animated: false)
    }
    
    func execVolumeMore() {
        let  audioSession = AVAudioSession.sharedInstance()
        var volume : Float = audioSession.outputVolume
        volume += 0.05
        print(volume)
        (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(volume, animated: false)
    }
    
    //IBACTIONS
    
    @IBAction func onSpotifyLogin(_ sender: Any) {
        setup()
        guard let loginUrl = self.loginUrl else { return }
        
        UIApplication.shared.open(loginUrl, options: [:]) { (bool) in
            if bool && self.auth.canHandle(self.auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
    
    @IBAction func onPlayPause(_ sender: UIButton) {
        execPlayPause(sender: sender)
    }
    
    func activateAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func execCommands(receiveMessage : String){
        guard canExecCommands else { return }
        switch receiveMessage {
        case "PlayPause":
            execPlayPause(sender: playBtn)
            break
        case "Next":
            execNext()
            break
        case "Prev":
            execPrevious()
            break
        case "More":
            execVolumeMore()
            break
        case "Less":
            execVolumeLess()
            break
        default:
            break
        }
    }
    
    // MARK: Deactivate audio session
    
    func deactivateAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    @IBAction func onNext(_ sender: Any) {
        execNext()
    }
    
    @IBAction func onPrevious(_ sender: Any) {
        execPrevious()
    }
    
    @IBAction func onLoop(_ sender: Any) {
        //guard let player = self.player else { return }
        
    }
    
    @IBAction func onRandom(_ sender: Any) {
    }
}

extension ViewController : SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        playButtons.isHidden = false
        getUserPlaylists()
        self.titleView.isHidden = false
        self.loginButton.isHidden = true
    }
    
    func audioStreamingDidEncounterTemporaryConnectionError(_ audioStreaming: SPTAudioStreamingController!) {
        print(audioStreaming)
    }

    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        if isPlaying {
            self.activateAudioSession()
        } else {
            self.deactivateAudioSession()
        }
    }
}

extension ViewController : CocoaMQTTDelegate{
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck){
        print("\n ==== didConnectAck ====")
        isMqttConnected = true
        mqtt.subscribe("showerSong/")
        mqtt.subscribe("showerSong/connection/")
        if !boxConnected{
            self.mqtt.publish("showerSong/connection/", withString: "1") //1 = appli connecté
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                if self.boxConnected{
                    timer.invalidate()
                }else{
                    mqtt.disconnect()
                    self.isMqttConnected = false
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                        self.setupMqtt()
                    })
                }
            })
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16){
        guard let sendMessage = message.string else { return }
        print("\n ==== didPublishMessage ====   \(message.topic)\(sendMessage)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16){
        //print("\n ==== didPublishAck ====   \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ){
        guard let receiveMessage = message.string else { return }
        print("\n ==== didReceiveMessage ====   \(message.topic)\(receiveMessage) \t-\t \(Date())")
        
        if message.topic.contains("connection"){
            if receiveMessage.contains("2") { //box co
                boxConnected = true
                clockManager()
                connectedView.backgroundColor = #colorLiteral(red: 0, green: 0.8049334288, blue: 0, alpha: 1)
            }
            if receiveMessage.contains("0") { //box deco
                boxConnected = false
                connectedView.backgroundColor = #colorLiteral(red: 0.8334491849, green: 0.1151285842, blue: 0, alpha: 1)
            }
            return
        }
        
        if !needWait{
            lastMqttMessage = receiveMessage
            execCommands(receiveMessage: receiveMessage)
            needWait = true
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                self.needWait = false
            }
        }else if receiveMessage == self.lastMqttMessage{
            self.execCommands(receiveMessage: receiveMessage)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String){
        print("\n ==== didSubscribeTopic ====")
        print(topic)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String){
        print("\n ==== didUnsubscribeTopic ====")
        self.mqtt.subscribe(topic)
        print(topic)
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT){
        print("\n ==== mqttDidPing ====")
        print(mqtt)
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT){
        print("\n ==== mqttDidReceivePong ====")
        print(mqtt)
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?){
        print("\n ==== mqttDidDisconnect ====")
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        //}
        if boxConnected{
            self.setupMqtt()
        }
        print(mqtt)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void){
        print("\n ==== didReceive trust ====")
        print(trust)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishComplete id: UInt16){
        print("\n ==== didPublishComplete ====")
        self.mqtt.disconnect()
        print(id)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState){
        //print("\n ==== didStateChangeTo ====    \(state)")
    }
    
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : PlaylistCell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as? PlaylistCell else { return UITableViewCell() }
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, tableview : UITableView? = nil) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
                if let tableview = tableview{
                    tableview.reloadData()
                }
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, tableview : UITableView? = nil) {
        guard let url = URL(string: link) else { return }
        if let tableview = tableview{
            downloadedFrom(url: url, contentMode: mode, tableview : tableview)
            return
        }
        downloadedFrom(url: url, contentMode: mode)
    }
}
