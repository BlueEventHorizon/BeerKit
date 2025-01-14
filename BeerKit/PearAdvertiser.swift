//
//  Advertiser.swift
//  BeerKit
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import MultipeerConnectivity

class PearAdvertiser: NSObject, MCNearbyServiceAdvertiserDelegate {

    let session: MCSession
    var isAdvertising: Bool = false
    
    init(session: MCSession) {
        self.session = session
        super.init()
    }

    private var advertiser: MCNearbyServiceAdvertiser?

    func start(serviceType: String, discoveryInfo: [String: String]? = nil) {
        guard !isAdvertising else {
            return
        }

        isAdvertising = true
        advertiser = MCNearbyServiceAdvertiser(peer: session.myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }

    func stop() {
        guard isAdvertising else {
            return
        }

        advertiser?.delegate = nil
        advertiser?.stopAdvertisingPeer()
    }

    func restart() {
        if isAdvertising {
            stop()
        }

        advertiser?.startAdvertisingPeer()
        advertiser?.delegate = self
    }

    // ------------------------------------------------------------------------------------------
    // MARK: - MCNearbyServiceAdvertiserDelegate
    // ------------------------------------------------------------------------------------------
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}
