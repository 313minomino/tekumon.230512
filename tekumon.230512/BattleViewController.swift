//
//  BattleViewController.swift
//  tekumon.230512
//
//  Created by 酒井実 on 2023/05/12.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPBar: UIProgressView!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPBar: UIProgressView!
    
    var player: Player!
    var enemy: Enemy!
    
    var enemyAttackTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        enemyHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        
        player = Player(name: "勇者", imageName: "yusya.png", attackPoint: 20, maxHP: 100)
        enemy = Enemy(name: "ドラゴン", imageName: "manster.png", attackPoint: 10, maxHP: 300)
        
        playerNameLabel.text = player.name
        playerImageView.image = enemy.image
        
        enemyNameLabel.text = player.name
        enemyImageView.image = enemy.image
        
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TechMonManager.playBGM(fileName: "BGM_battle001")
        
        enemyAttackTimer = Timer.scheduledTimer(
            timeInterval: 1.5, target: self, selector: #selector(enemyAttack), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        TechMonManager.stopBGM()
    }
    func updateUI() {
        playerHPBar.progress = player.currentHP / player.maxHP
        enemyHPBar.progress = enemy.currentHP / enemy.maxHP
        if player.currentHP <= 0 {
                finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
            }
    }
    @IBAction func attackAction() {
        TechMonManager.damageAnimation(imageView: enemyImageView)
        TechMonManager.playSE(fileName: "SE_attack")
        
        enemy.currentHP -= player.attackPoint
        
        player.currentTP += 5
        if player.currentTP >= player.maxTP {
            player.currentTP = player.maxTP
        }
        
        updateUI()
        
        if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    @IBAction func chargeAction() {
        TechMonManager.playSE(fileName: "SE_charge")
        
        player.currentTP += 20
        if player.currentTP >= player.maxTP {
            player.currentTP = player.maxTP
        }
        
        updateUI()
        
    }
    @IBAction func fireAction() {
        if player.currentTP >= player.maxTP {
            TechMonManager.damageAnimation(imageView: enemyImageView)
            TechMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= player.fireAttackPoint
            player.currentTP = 0
        }
        updateUI()
        
        if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    @objc func enemyAttack() {
        TechMonManager.damageAnimation(imageView: playerImageView)
        TechMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= enemy.attackPoint
        
    }
    
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        TechMonManager.vanishAnimation(imageView: vanishImageView)
        TechMonManager.stopBGM()
        enemyAttackTimer.invalidate()
        
        var finishMessage: String = ""
        if isPlayerWin {
            TechMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        } else {
            TechMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北…"
        }
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in self.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
}
