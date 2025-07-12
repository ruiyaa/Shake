//
//  ShakeDetector.swift
//  shake-swiftui
//
//  Created by Kyoya Yamaguchi on 2025/05/29.
//

import Combine
import CoreMotion
import Foundation

class ShakeDetector: ObservableObject {
    @Published var shakeCount = 0

    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    private let shakeThreshold: Double = 2.0

    init() {
        startAccelerometer()
    }

    private func startAccelerometer() {
        guard motionManager.isAccelerometerAvailable else { return }

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, _ in
            guard let self, let data else { return }

            let acceleration = data.acceleration
            if fabs(acceleration.x) > 2.0 || fabs(acceleration.y) > 2.0 || fabs(acceleration.z) > 2.0 {
                DispatchQueue.main.async {
                    self.shakeCount += 1
                    print(self.shakeCount)
                }
            }
        }
    }

    deinit {
        motionManager.stopAccelerometerUpdates()
    }
}
