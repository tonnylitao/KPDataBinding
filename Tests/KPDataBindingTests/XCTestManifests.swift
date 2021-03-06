import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OneWayBindingTests.allTests),
        testCase(OneWayOperatorTests.allTests),
    ]
}
#endif
