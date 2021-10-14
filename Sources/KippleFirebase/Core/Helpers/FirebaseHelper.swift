// Copyright © 2021 Brian Drelling. All rights reserved.

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import KippleDiagnostics

public enum FirebaseHelper {
    // MARK: Constants

    private static let localHostname = "bribook.local"

    // MARK: Enums

    public enum Mode {
        case local
        case beta
        case release
    }

    // MARK: Initializers

    public static func initialize(options: FirebaseOptions, isLocal: Bool) {
//        FirebaseConfiguration.shared.setLoggerLevel(.debug)

        FirebaseApp.configure(options: options)
        KippleLogger.debug("Firebase has been configured.")

        if isLocal {
            self.initializeForLocalDevelopment()
        }
    }

    public static func initialize(filePath: String, isLocal: Bool) {
        if let options = FirebaseOptions(contentsOfFile: filePath) {
            self.initialize(options: options, isLocal: isLocal)
        } else {
            KippleLogger.report("Firebase failed to initialize! Unable to find GoogleServices file at '\(filePath)'.")
        }
    }

    private static func initializeForLocalDevelopment() {
        // Signs out the locally authenticated user.

        // Auth
        Auth.auth().useEmulator(withHost: self.localHostname, port: 9099)

        // Firestore
        let settings = Firestore.firestore().settings
        settings.host = "\(self.localHostname):8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false

        Firestore.firestore().settings = settings
    }
}