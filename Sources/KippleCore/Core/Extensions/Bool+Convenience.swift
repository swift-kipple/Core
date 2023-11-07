// Copyright © 2023 Brian Drelling. All rights reserved.

import Foundation

public extension Bool {
    /// Whether or not the `DEBUG` flag is defined, which typically indicates a Debug build configuration.
    static let isDebugging: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()

    /// Whether or not the app is running unit tests.
    static let isRunningUnitTests: Bool = NSClassFromString("XCTestCase") != nil
}

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)

public extension Bool {
    /// Whether or not this code is running within Xcode SwiftUI Previews, which has limited functionality.
    static let isRunningInXcodePreview: Bool = {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        return false
        #endif
    }()

    /// Whether or not the app is running on the simulator.
    static let isRunningOnSimulator: Bool = {
        #if targetEnvironment(simulator)
        true
        #else
        false
        #endif
    }()

    /// Whether or not the application is running via TestFlight.
    ///
    /// Source: [StackOverflow](https://stackoverflow.com/a/38984554)
    static let isRunningOnTestFlight: Bool = Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") ?? false

    /// Whether or not the currently running build is an internal build for developers, employees, and/or beta-testers.
    static let isRunningInternalBuild: Bool = .isDebugging || .isRunningOnSimulator || .isRunningOnTestFlight

    /// Whether or not the app is running UI tests.
    ///
    /// Note: This can only be detected if the `-ui_testing` flag is provided as a launch argument
    /// to the application being tested. This can be done programmatically or in the Xcode Scheme.
    static let isRunningUITests: Bool = ProcessInfo.processInfo.arguments.contains("-ui_testing")

    /// Whether or not the app is running unit or UI tests.
    ///
    /// On non-Apple environments, this property is simply an alias for `isRunningUnitTests`.
    static let isRunningTests: Bool = .isRunningUnitTests || .isRunningUITests

    /// Whether or not the application should mock external services, from networking to hardware operations.
    /// This is used primarily for testing and Xcode Previews in order to improve performance.
    static let shouldMockExternalServices: Bool = .isRunningTests || .isRunningInXcodePreview
}

#else

public extension Bool {
    /// Whether or not the app is running unit tests.
    ///
    /// On non-Apple environments, this property is simply an alias for `isRunningUnitTests`.
    static let isRunningTests: Bool = .isRunningUnitTests
}

#endif