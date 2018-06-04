import XCTest

import Benchmark

var tests = [XCTestCaseEntry]()
tests += Benchmark.allTests()
XCTMain(tests)
