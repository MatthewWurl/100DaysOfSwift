//
//  CollectionViewController.swift
//  SelfieShare
//
//  Created by Matt X on 1/7/23.
//

import MultipeerConnectivity
import UIKit

class CollectionViewController: UICollectionViewController,
                                MCBrowserViewControllerDelegate,
                                MCSessionDelegate,
                                UINavigationControllerDelegate,
                                UIImagePickerControllerDelegate {
    var images: [UIImage] = []
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    var mcSession: MCSession?
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        
        let cameraButton = UIBarButtonItem(
            barButtonSystemItem: .camera,
            target: self,
            action: #selector(importPicture)
        )
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(showConnectionPrompt))
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = cameraButton
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    func hostSession(_ action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "mw-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(_ action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        
        let mcBrowserVC = MCBrowserViewController(serviceType: "mw-project25", session: mcSession)
        mcBrowserVC.delegate = self
        
        present(mcBrowserVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(
                        title: "Send error",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    present(ac, animated: true)
                }
            }
        }
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(
            title: "Connect to others",
            message: nil,
            preferredStyle: .alert
        )
        ac.addAction(
            UIAlertAction(title: "Host a session", style: .default, handler: hostSession)
        )
        ac.addAction(
            UIAlertAction(title: "Join a session", style: .default, handler: joinSession)
        )
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Not connected: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
}
