//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// This test file has been translated from swift/test/Parse/foreach_async.swift

import XCTest

final class ForeachAsyncTests: XCTestCase {
  func testForeachAsync1() {
    AssertParse(
      """
      import _Concurrency
      """
    )
  }

  func testForeachAsync2() {
    AssertParse(
      """
      struct AsyncRange<Bound: Comparable & Strideable>: AsyncSequence, AsyncIteratorProtocol where Bound.Stride : SignedInteger {
        var range: Range<Bound>.Iterator
        typealias Element = Bound
        mutating func next() async -> Element? { return range.next() }
        func cancel() { }
        func makeAsyncIterator() -> Self { return self }
      }
      """
    )
  }

  func testForeachAsync3() {
    AssertParse(
      """
      struct AsyncIntRange<Int> : AsyncSequence, AsyncIteratorProtocol {
        typealias Element = (Int, Int)
        func next() async -> (Int, Int)? {}
        func cancel() { }
        typealias AsyncIterator = AsyncIntRange<Int>
        func makeAsyncIterator() -> AsyncIntRange<Int> { return self }
      }
      """
    )
  }

  func testForeachAsync4() {
    AssertParse(
      """
      func for_each(r: AsyncRange<Int>, iir: AsyncIntRange<Int>) async { 
        var sum = 0
        // Simple foreach loop, using the variable in the body
        for await i in r {
          sum = sum + i
        }
        // Check scoping of variable introduced with foreach loop
        i = 0 
        // For-each loops with two variables and varying degrees of typedness
        for await (i, j) in iir {
          sum = sum + i + j
        }
        for await (i, j) in iir {
          sum = sum + i + j
        }
        for await (i, j) : (Int, Int) in iir {
          sum = sum + i + j
        }
        // Parse errors
        for await i 1️⃣r { 
        }         
        for await i in r 2️⃣sum = sum + i;3️⃣
      }
      """,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "expected 'in' in 'for' statement"),
        DiagnosticSpec(locationMarker: "2️⃣", message: "expected '{' in 'for' statement"),
        DiagnosticSpec(locationMarker: "3️⃣", message: "expected '}' to end 'for' statement"),
      ]
    )
  }

}
