import Foundation
import BackgroundTasks
import SwiftUI

struct BackgroundTask {
    static func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Const.BUNDLE_ID, using: nil) { task in
            handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    static func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            print("Scheduling background task.")
            scheduleAppRefresh()
        default:
            break
        }
    }

    static func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Const.BUNDLE_ID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30)

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background refresh task scheduled.")
        } catch {
            print("Failed to schedule: \(error)")
        }
    }

    static func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()

        triggerUserOffline()

        task.setTaskCompleted(success: true)
    }

    static func triggerUserOffline() {
        print("user marked offline.")
        
        do {
            let success = try UserMaintenanceQueries.changeUserToOffline(email: Session.shared.getUserEmail()!)
            if success {
                print("User marked as offline.")
            }
        } catch {
            print("Failed to mark user as offline: \(error)")
        }
    }
}
