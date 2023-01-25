//
//  ViewController.swift
//  EggTimer
//
//  Created by Aleksey Kosov on 25.01.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var timer: Timer?
    var audioPlayer = AVAudioPlayer()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How would you like your eggs?"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()

    let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        label.font = .systemFont(ofSize: 40)
        label.isHidden = false
        return label
    }()

    let progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.progress = 0
        bar.tintColor = .systemOrange
        bar.isHidden = true
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        createEggViews()
        setupUI()
    }

    var runCount = 0

    enum EggTimes: Int {
        case softTime = 1
        case mediumTime = 7
        case hardTime = 12
    }


    func createEggViews() {
        let softEgg = EggView(target: self, selector: #selector(hardnessSelected), imageName: "soft_egg", title: "Soft")
        let mediumEgg = EggView(target: self, selector: #selector(hardnessSelected), imageName: "medium_egg", title: "Medium")
        let hardEgg = EggView(target: self, selector: #selector(hardnessSelected), imageName: "hard_egg", title: "Hard")

        let eggStackView = UIStackView(arrangedSubviews: [
            softEgg,
            mediumEgg,
            hardEgg
        ])
        eggStackView.axis = .horizontal
        eggStackView.distribution = .fillEqually
        eggStackView.spacing = 12
        eggStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eggStackView)

        NSLayoutConstraint.activate([
            eggStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            eggStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            eggStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            eggStackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func setupUI() {
        view.addSubview(timerLabel)
        view.addSubview(titleLabel)
        view.addSubview(progressBar)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            timerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            timerLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: 40),

            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            progressBar.heightAnchor.constraint(equalToConstant: 3)
        ])
    }

    var timeToBoil = 0

    @objc func fireTimer(timer: Timer) {
        let timeInSeconds = timeToBoil * 60

        progressBar.progress = Float(runCount) / Float(timeInSeconds)

        print(Float(runCount) / Float(timeInSeconds))

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(timeInSeconds - runCount))!
        timerLabel.text = formattedString
        runCount += 1

        if runCount == timeInSeconds {
            resetTimer(timer)
            playSound()
        }
    }

    fileprivate func resetTimer(_ timer: Timer) {
        timer.invalidate()
        timeToBoil = 0
        runCount = 0
        progressBar.progress = 0
        progressBar.isHidden = true
        timerLabel.isHidden = true
        timerLabel.text = "Done"
    }

    @objc func hardnessSelected(sender: UIButton) {
        if let timer {
            resetTimer(timer)
        }

        let hardness = sender.currentTitle

        switch hardness {
        case "Soft": print(EggTimes.softTime)
            timeToBoil = EggTimes.softTime.rawValue
        case "Medium": print(EggTimes.mediumTime)
            timeToBoil = EggTimes.mediumTime.rawValue
        case "Hard": print(EggTimes.hardTime)
            timeToBoil = EggTimes.hardTime.rawValue
        default: break
        }
        progressBar.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }

    private func playSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "alarm_sound", ofType: "mp3")!))
            audioPlayer.play()
        } catch {
            print(error)
        }
    }
}

