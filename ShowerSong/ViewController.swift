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

class ViewController: UIViewController {
 
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playButtons: UIView!
    
    
    // Variables
    var auth = SPTAuth.defaultInstance()!
    
    // Initialzed in either updateAfterFirstLogin: (if first time login) or in viewDidLoad (when there is a check for a session object in User Defaults
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    var session: SPTSession?
    
    var playlistShowerUri : URL?
    var mqtt : CocoaMQTT!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        self.mqtt = CocoaMQTT(clientID: clientID, host: "vps363392.ovh.net", port: 8080)
        self.mqtt.delegate = self
        print(mqtt.clientID)
        self.mqtt.connect()
        //mqtt.subscribe("showerShong/")

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        if let sessionObj:AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject?,
            let sessionDataObj = sessionObj as? Data,
            let session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession{
            
            self.session = session
            if session.isValid(){
                self.loginButton.isHidden = true
                initializaPlayer(authSession: session)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAfterFirstLogin () {
        
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject?,
            let sessionDataObj = sessionObj as? Data,
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession{
            
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
                getUserPlaylists()
            }
        }
    }

    func setup () {
        // insert redirect your url and client ID below
        let redirectURL = "ShowerSong://returnAfterLogin" // put your redirect URL here
        let clientID = "36c5e0558e0545bd93592e79f1c32e02" // put your client ID here
        auth.redirectURL     = URL(string: redirectURL)
        auth.clientID        = clientID
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    func getUserPlaylists(){
        guard let session = self.session else { return }
        SPTPlaylistList.playlists(forUser: session.canonicalUsername, withAccessToken: session.accessToken, callback: { (error, response) in
            //pb ici
            if let listPage = response as? SPTPlaylistList, let playlists = listPage.items as? [SPTPartialPlaylist] {
                for playlist in playlists {
                    if playlist.name.lowercased().contains("shower") {
                        self.playlistShowerUri = playlist.uri
                    }
                }
            }
        })
        
    }
    
    func execPlayPause(sender : UIButton){
        guard
            let player = self.player,
            let playlistURL = self.playlistShowerUri else { return }
        if sender.tag == 0 {
            if player.playbackState != nil {
                player.setIsPlaying(true, callback: { (error) in
                    sender.tag = 1
                    sender.setTitle("Pause", for: .normal)
                })
            }else{
                player.playSpotifyURI(playlistURL.absoluteString, startingWith: 0, startingWithPosition: 0, callback: { (error) in
                    if (error == nil) {
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
    
    // MARK: Deactivate audio session
    
    func deactivateAudioSession() {
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    @IBAction func onNext(_ sender: Any) {
        guard let player = self.player else { return }
        player.skipNext(nil)
    }
    
    @IBAction func onPrevious(_ sender: Any) {
        guard let player = self.player else { return }
        player.skipPrevious(nil)
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
        print(ack)
        mqtt.subscribe("showerShong/")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16){
        guard let sendMessage = message.string else { return }
        print("\n ==== didPublishMessage ====   \(message.topic)\(sendMessage)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16){
        print("\n ==== didPublishAck ====   \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ){
        guard let receiveMessage = message.string else { return }
        print("\n ==== didReceiveMessage ====   \(message.topic)\(receiveMessage) \t-\t \(Date())")
        
        execPlayPause(sender: playBtn)
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
            self.mqtt.connect()
        //}
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
