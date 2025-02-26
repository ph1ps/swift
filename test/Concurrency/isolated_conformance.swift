// RUN: %target-swift-frontend -typecheck -verify -target %target-swift-5.1-abi-triple -swift-version 6 -enable-experimental-feature IsolatedConformances %s

// REQUIRES: swift_feature_IsolatedConformances

protocol P {
  func f() // expected-note 2{{mark the protocol requirement 'f()' 'async' to allow actor-isolated conformances}}
}

// expected-note@+3{{add '@preconcurrency' to the 'P' conformance to defer isolation checking to run time}}{{25-25=@preconcurrency }}
// expected-note@+2{{add 'isolated' to the 'P' conformance to restrict it to main actor-isolated code}}{{25-25=isolated }}
@MainActor
class CWithNonIsolated: P {
  func f() { } // expected-error{{main actor-isolated instance method 'f()' cannot be used to satisfy nonisolated requirement from protocol 'P'}}
  // expected-note@-1{{add 'nonisolated' to 'f()' to make this instance method not isolated to the actor}}
}

actor SomeActor { }

// Isolated conformances need a global-actor-constrained type.
class CNonIsolated: isolated P { // expected-error{{isolated conformance is only permitted on global-actor-isolated types}}
  func f() { }
}

extension SomeActor: isolated P { // expected-error{{isolated conformance is only permitted on global-actor-isolated types}}
  nonisolated func f() { }
}

@globalActor
struct SomeGlobalActor {
  static let shared = SomeActor()
}

// Isolation of the function needs to match that of the enclosing type.
@MainActor
class CMismatchedIsolation: isolated P {
  @SomeGlobalActor func f() { } // expected-error{{global actor 'SomeGlobalActor'-isolated instance method 'f()' cannot be used to satisfy nonisolated requirement from protocol 'P'}}
}

@MainActor
class C: isolated P {
  func f() { } // okay
}
