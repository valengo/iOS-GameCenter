//
//  GameCenter.swift
//  findot
//
//  Created by Andressa Valengo on 04/03/20.
//  Copyright © 2020 Andressa Valengo. All rights reserved.
//

import GameKit

class GameCenter: NSObject, GKGameCenterControllerDelegate {
    
    static let shared = GameCenter()
    
    private(set) var isGameCenterEnabled = false
    
    private let localPlayer = GKLocalPlayer.local
    
    private let leaderboardID = "YOU_LEADERBOARD_ID"
            
    private override init() {
        
    }
    
    func authenticateLocalPlayer(presentingVC: UIViewController) {
        localPlayer.authenticateHandler = { [weak self] (gameCenterViewController, error) -> Void in
            if let error = error {
                print(error)
            } else if let gameCenterViewController = gameCenterViewController {
                presentingVC.present(gameCenterViewController, animated: true, completion: nil)
            } else if (self?.localPlayer.isAuthenticated ?? false) {
                self?.isGameCenterEnabled = true
            } else {
                self?.isGameCenterEnabled = false
                print("Local player cannot be authenticated!")
            }
        }
    }
    
    func updateScore(with value: Int) {
        let score = GKScore(leaderboardIdentifier: leaderboardID)
        score.value = Int64(value)
        GKScore.report([score], withCompletionHandler: {(error) in
            if let error = error {
                print("Error while trying to update score \(error)")
            }
        })
    }
    
    func showLeaderboard(presentingVC: UIViewController) {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = .leaderboards
        gameCenterViewController.leaderboardIdentifier = leaderboardID
        presentingVC.present(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
