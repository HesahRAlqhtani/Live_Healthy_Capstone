//
//  CoreMotionUser.swift
//  Live_Healthy
//
//  Created by Hesah Alqhtani on 29/12/2021.
//

import UIKit
import CoreMotion

class CoreMotionUser: UIViewController {
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    private var shouldStartUpdating: Bool = false
    private var startDate: Date? = nil

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var activityTypeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let startDate = startDate else { return }
        updateStepsCountLabelUsing(startDate: startDate)
    }

    @objc private func didTapStartButton() {
        shouldStartUpdating = !shouldStartUpdating
        shouldStartUpdating ? (onStart()) : (onStop())
    }
}

extension CoreMotionUser {
    
    private func onStart() {
        startButton.setTitle("Stop".loclaized, for: .normal)
        startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }
    
    private func onStop() {
        startButton.setTitle("Start".loclaized, for: .normal)
        startDate = nil
        stopUpdating()
    }
    
    private func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            activityTypeLabel.text = "Not available".loclaized
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        } else {
            stepsCountLabel.text = "Not available".loclaized
        }
    }
    
    private func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            onStop()
            activityTypeLabel.text = "Not available"
            stepsCountLabel.text = "Not available"
        default:break
        }
    }
    
    private func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }
    
    private func on(error: Error) {
        //handle error
    }
    
    private func updateStepsCountLabelUsing(startDate: Date) {
        pedometer.queryPedometerData(from: startDate, to: Date()) {
            [weak self] pedometerData, error in
            if let error = error {
                self?.on(error: error)
            } else if let pedometerData = pedometerData {
                DispatchQueue.main.async {
                    self?.stepsCountLabel.text = String(describing: pedometerData.numberOfSteps)
                }
            }
        }
    }
    
    private func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    self?.activityTypeLabel.text = "Walking".loclaized
                } else if activity.stationary {
                    self?.activityTypeLabel.text = "Stationary".loclaized
                } else if activity.running {
                    self?.activityTypeLabel.text = "Running".loclaized
                } else if activity.automotive {
                    self?.activityTypeLabel.text = "Automotive".loclaized
                }
            }
        }
    }
    
    private func startCountingSteps() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.stepsCountLabel.text = pedometerData.numberOfSteps.stringValue
            }
        }
    }
}
