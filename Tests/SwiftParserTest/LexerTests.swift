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

import XCTest
@_spi(RawSyntax) import SwiftSyntax
@_spi(RawSyntax) import SwiftParser

fileprivate func lex(_ sourceBytes: [UInt8]) -> [Lexer.Lexeme] {
  return sourceBytes.withUnsafeBufferPointer { (buf) -> [Lexer.Lexeme] in
    var lexemes = [Lexer.Lexeme]()
    for token in Lexer.tokenize(buf, from: 0) {
      lexemes.append(token)

      if token.rawTokenKind == .eof {
        break
      }
    }
    return lexemes
  }
}

/// `LexemeSpec` heavily relies on string literals to represent the expected
/// values for trivia and text. While this is good for most cases, string
/// literals can't contain invalid UTF-8. Thus, we need a different assert
/// function working on byte arrays to test source code containing invalid UTF-8.
fileprivate func AssertRawBytesLexeme(
  _ lexeme: Lexer.Lexeme,
  kind: RawTokenKind,
  leadingTrivia: [UInt8] = [],
  text: [UInt8],
  trailingTrivia: [UInt8] = [],
  file: StaticString = #file,
  line: UInt = #line
) {
  XCTAssertEqual(lexeme.rawTokenKind, kind, file: file, line: line)
  leadingTrivia.withUnsafeBufferPointer { leadingTrivia in
    XCTAssertEqual(lexeme.leadingTriviaText, SyntaxText(buffer: leadingTrivia), file: file, line: line)
  }
  text.withUnsafeBufferPointer { text in
    XCTAssertEqual(lexeme.tokenText, SyntaxText(buffer: text), file: file, line: line)
  }
  trailingTrivia.withUnsafeBufferPointer { trailingTrivia in
    XCTAssertEqual(lexeme.trailingTriviaText, SyntaxText(buffer: trailingTrivia), file: file, line: line)
  }
}

public class LexerTests: XCTestCase {
  func testIdentifiers() {
    AssertLexemes(
      "Hello World",
      lexemes: [
        LexemeSpec(.identifier, text: "Hello", trailing: " "),
        LexemeSpec(.identifier, text: "World"),
      ]
    )
  }

  func testEscapedIdentifiers() {
    AssertLexemes(
      "`Hello` `World` `$`",
      lexemes: [
        LexemeSpec(.identifier, text: "`Hello`", trailing: " "),
        LexemeSpec(.identifier, text: "`World`", trailing: " "),
        LexemeSpec(.identifier, text: "`$`"),
      ]
    )
  }

  func testBlockComments() {
    AssertLexemes(
      """
      /*/ */
      func not_doc5() {}
      """,
      lexemes: [
        LexemeSpec(.keyword(.func), leading: "/*/ */\n", text: "func", trailing: " ", flags: [.isAtStartOfLine]),
        LexemeSpec(.identifier, text: "not_doc5"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.rightParen, text: ")", trailing: " "),
        LexemeSpec(.leftBrace, text: "{"),
        LexemeSpec(.rightBrace, text: "}"),
      ]
    )

    AssertLexemes(
      """
      /* */
      /**/
      /* /* */ */
      """,
      lexemes: [
        LexemeSpec(.eof, leading: "/* */\n/**/\n/* /* */ */", text: "", flags: [.isAtStartOfLine])
      ]
    )
  }

  func testDeepTupleAccess() {
    AssertLexemes(
      "x.1.0",
      lexemes: [
        LexemeSpec(.identifier, text: "x"),
        LexemeSpec(.period, text: "."),
        LexemeSpec(.integerLiteral, text: "1"),
        LexemeSpec(.period, text: "."),
        LexemeSpec(.integerLiteral, text: "0"),
      ]
    )
  }

  func testUnicodeLiteral() {
    AssertLexemes(
      #"""
      "\u{1234}"
      """#,
      lexemes: [
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: #"\u{1234}"#),
        LexemeSpec(.stringQuote, text: #"""#),
      ]
    )

    AssertLexemes(
      #"""
      "\u{12341234}"
      """#,
      lexemes: [
        // FIXME: We should diagnose invalid unicode characters in string literals
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: #"\u{12341234}"#),
        LexemeSpec(.stringQuote, text: #"""#),
      ]
    )
  }

  func testNumberLiterals() {
    AssertLexemes(
      "1234567890",
      lexemes: [
        LexemeSpec(.integerLiteral, text: "1234567890")
      ]
    )
    AssertLexemes(
      "0b1010101",
      lexemes: [
        LexemeSpec(.integerLiteral, text: "0b1010101")
      ]
    )
    AssertLexemes(
      "0xABC",
      lexemes: [
        LexemeSpec(.integerLiteral, text: "0xABC")
      ]
    )
    AssertLexemes(
      "1.0",
      lexemes: [
        LexemeSpec(.floatingLiteral, text: "1.0")
      ]
    )
    AssertLexemes(
      "1.0e10",
      lexemes: [
        LexemeSpec(.floatingLiteral, text: "1.0e10")
      ]
    )
    AssertLexemes(
      "1.0E10",
      lexemes: [
        LexemeSpec(.floatingLiteral, text: "1.0E10")
      ]
    )
    AssertLexemes(
      "0xfeed_beef",
      lexemes: [
        LexemeSpec(.integerLiteral, text: "0xfeed_beef")
      ]
    )
    AssertLexemes(
      "0xff.0p2",
      lexemes: [
        LexemeSpec(.floatingLiteral, text: "0xff.0p2")
      ]
    )
    AssertLexemes(
      "-0xff.0p2",
      lexemes: [
        LexemeSpec(.prefixOperator, text: "-"),
        LexemeSpec(.floatingLiteral, text: "0xff.0p2"),
      ]
    )
    AssertLexemes(
      "+0xff.0p2",
      lexemes: [
        LexemeSpec(.prefixOperator, text: "+"),
        LexemeSpec(.floatingLiteral, text: "0xff.0p2"),
      ]
    )
    AssertLexemes(
      "0x1.921fb4p1",
      lexemes: [
        LexemeSpec(.floatingLiteral, text: "0x1.921fb4p1")
      ]
    )
  }

  func testRawStringLiterals() {
    AssertLexemes(
      """
      ###"this is a ##"raw"## string"###
      """,
      lexemes: [
        LexemeSpec(.rawStringDelimiter, text: "###"),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: ###"this is a ##"raw"## string"###),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.rawStringDelimiter, text: "###"),
      ]
    )

    AssertLexemes(
      """
      #"#"abc"#
      """,
      lexemes: [
        LexemeSpec(.rawStringDelimiter, text: "#"),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: #"#"abc"#),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.rawStringDelimiter, text: "#"),
      ]
    )

    AssertLexemes(
      """
      ###"##"abc"###
      """,
      lexemes: [
        LexemeSpec(.rawStringDelimiter, text: "###"),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: #"##"abc"#),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.rawStringDelimiter, text: "###"),
      ]
    )

    AssertLexemes(
      #####"""
      ##"""abc"####
      """#####,
      lexemes: [
        LexemeSpec(.rawStringDelimiter, text: "##"),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: ###"""abc"###),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.rawStringDelimiter, text: "####"),
      ]
    )
  }

  func testShebang() {
    AssertLexemes(
      """
      #!/usr/bin/swiftc
      let x = 42
      """,
      lexemes: [
        LexemeSpec(.keyword(.let), leading: "#!/usr/bin/swiftc\n", text: "let", trailing: " ", flags: [.isAtStartOfLine]),
        LexemeSpec(.identifier, text: "x", trailing: " "),
        LexemeSpec(.equal, text: "=", trailing: " "),
        LexemeSpec(.integerLiteral, text: "42"),
      ]
    )
  }

  func testDocComment() {
    AssertLexemes(
      """
      /** hello */
      var x: Int
      /* regular comment */
      """,
      lexemes: [
        LexemeSpec(.keyword(.var), leading: "/** hello */\n", text: "var", trailing: " ", flags: [.isAtStartOfLine]),
        LexemeSpec(.identifier, text: "x"),
        LexemeSpec(.colon, text: ":", trailing: " "),
        LexemeSpec(.identifier, text: "Int"),
        LexemeSpec(.eof, leading: "\n/* regular comment */", text: "", flags: [.isAtStartOfLine]),
      ]
    )
  }

  func testMain() {
    AssertLexemes(
      """
      /* TestApp */
      @main struct TestApp {
        static func main() {
          print("Hello World")
        }
      }
      """,
      lexemes: [
        LexemeSpec(.atSign, leading: "/* TestApp */\n", text: "@", flags: [.isAtStartOfLine]),
        LexemeSpec(.identifier, text: "main", trailing: " "),
        LexemeSpec(.keyword(.struct), text: "struct", trailing: " "),
        LexemeSpec(.identifier, text: "TestApp", trailing: " "),
        LexemeSpec(.leftBrace, text: "{"),
        LexemeSpec(.keyword(.static), leading: "\n  ", text: "static", trailing: " ", flags: [.isAtStartOfLine]),
        LexemeSpec(.keyword(.func), text: "func", trailing: " "),
        LexemeSpec(.identifier, text: "main"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.rightParen, text: ")", trailing: " "),
        LexemeSpec(.leftBrace, text: "{"),
        LexemeSpec(.identifier, leading: "\n    ", text: "print", flags: [.isAtStartOfLine]),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: "Hello World"),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.rightParen, text: ")"),
        LexemeSpec(.rightBrace, leading: "\n  ", text: "}", flags: [.isAtStartOfLine]),
        LexemeSpec(.rightBrace, leading: "\n", text: "}", flags: [.isAtStartOfLine]),
      ]
    )
  }

  func testRegexLexing() {
    AssertLexemes(
      "/abc/",
      lexemes: [
        LexemeSpec(.regexLiteral, text: "/abc/")
      ]
    )
    AssertLexemes(
      "#/abc/#",
      lexemes: [
        LexemeSpec(.regexLiteral, text: "#/abc/#")
      ]
    )
    AssertLexemes(
      "###/abc/###",
      lexemes: [
        LexemeSpec(.regexLiteral, text: "###/abc/###")
      ]
    )
    AssertLexemes(
      """
      #/
      a
      b
      /#
      """,
      lexemes: [
        LexemeSpec(.regexLiteral, text: "#/\na\nb\n/#")
      ]
    )
    AssertLexemes(
      "#/ \na\nb\n  /#",
      lexemes: [
        LexemeSpec(.regexLiteral, text: "#/ \na\nb\n  /#")
      ]
    )
    AssertLexemes(
      "##/ \na\nb\n  /##",
      lexemes: [
        LexemeSpec(.regexLiteral, text: "##/ \na\nb\n  /##")
      ]
    )
    AssertLexemes(
      "#/abc/def/#",
      lexemes: [
        LexemeSpec(.regexLiteral, text: "#/abc/def/#")
      ]
    )
    AssertLexemes(
      "#/abc\\/#def/#",
      lexemes: [
        LexemeSpec(.regexLiteral, text: "#/abc\\/#def/#")
      ]
    )
    AssertLexemes(
      "#/abc|#def/#",
      lexemes: [
        LexemeSpec(.regexLiteral, text: "#/abc|#def/#")
      ]
    )
    AssertLexemes(
      "#/abc\n/#",
      lexemes: [
        LexemeSpec(.pound, text: "#"),
        LexemeSpec(.binaryOperator, text: "/"),
        LexemeSpec(.identifier, text: "abc"),
        LexemeSpec(.prefixOperator, leading: "\n", text: "/", flags: [.isAtStartOfLine]),
        LexemeSpec(.pound, text: "#"),
      ]
    )
    AssertLexemes(
      "#/abc\r/#",
      lexemes: [
        LexemeSpec(.pound, text: "#"),
        LexemeSpec(.binaryOperator, text: "/"),
        LexemeSpec(.identifier, text: "abc"),
        LexemeSpec(.prefixOperator, leading: "\r", text: "/", flags: [.isAtStartOfLine]),
        LexemeSpec(.pound, text: "#"),
      ]
    )
    AssertLexemes(
      "/a)/",
      lexemes: [
        LexemeSpec(.prefixOperator, text: "/"),
        LexemeSpec(.identifier, text: "a"),
        LexemeSpec(.rightParen, text: ")"),
        LexemeSpec(.postfixOperator, text: "/"),
      ]
    )
  }

  func testUnexpectedLexing() {
    AssertLexemes(
      "static func �() {}",
      lexemes: [
        LexemeSpec(.keyword(.static), text: "static", trailing: " "),
        LexemeSpec(.keyword(.func), text: "func", trailing: " �"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.rightParen, text: ")", trailing: " "),
        LexemeSpec(.leftBrace, text: "{"),
        LexemeSpec(.rightBrace, text: "}"),
      ]
    )
  }

  func testBOMLexing() {
    let bom: Unicode.Scalar = "\u{feff}"
    AssertLexemes(
      "\(bom)Hello",
      lexemes: [
        LexemeSpec(.identifier, leading: "\u{feff}", text: "Hello")
      ]
    )
  }

  func testConflictLexing() {
    AssertLexemes(
      """
      // diff3-style conflict markers

      <<<<<<< HEAD:conflict_markers.swift // expected-error {{source control conflict marker in source file}}
      var a : String = "A"
      var b : String = "b"
      =======
      var a : String = "a"
      var b : String = "B"
      >>>>>>> 18844bc65229786b96b89a9fc7739c0fc897905e:conflict_markers.swift
      """,
      lexemes: [
        LexemeSpec(
          .eof,
          leading:
            """
            // diff3-style conflict markers

            <<<<<<< HEAD:conflict_markers.swift // expected-error {{source control conflict marker in source file}}
            var a : String = "A"
            var b : String = "b"
            =======
            var a : String = "a"
            var b : String = "B"
            >>>>>>> 18844bc65229786b96b89a9fc7739c0fc897905e:conflict_markers.swift
            """,
          text: "",
          flags: [.isAtStartOfLine]
        )
      ]
    )

    AssertLexemes(
      """
      // Perforce-style conflict markers

      >>>> ORIGINAL
      var a : String = "A"
      var b : String = "B"
      ==== THEIRS
      var a : String = "A"
      var b : String = "b"
      ==== YOURS
      var a : String = "a"
      var b : String = "B"
      <<<<

      """,
      lexemes: [
        LexemeSpec(
          .eof,
          leading:
            """
            // Perforce-style conflict markers

            >>>> ORIGINAL
            var a : String = "A"
            var b : String = "B"
            ==== THEIRS
            var a : String = "A"
            var b : String = "b"
            ==== YOURS
            var a : String = "a"
            var b : String = "B"
            <<<<

            """,
          text: "",
          flags: [.isAtStartOfLine]
        )
      ]
    )
  }

  func testUnicodeStringLiteralLexing() {
    AssertLexemes(
      #"""
      "\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))"
      """#,
      lexemes: [
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: #"\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))"#),
        LexemeSpec(.stringQuote, text: #"""#),
      ]
    )
  }

  func testNotARegex() {
    AssertLexemes(
      "min(reduced.count / 2, chunkSize / 2)",
      lexemes: [
        LexemeSpec(.identifier, text: "min"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.identifier, text: "reduced"),
        LexemeSpec(.period, text: "."),
        LexemeSpec(.identifier, text: "count", trailing: " "),
        LexemeSpec(.binaryOperator, text: "/", trailing: " "),
        LexemeSpec(.integerLiteral, text: "2"),
        LexemeSpec(.comma, text: ",", trailing: " "),
        LexemeSpec(.identifier, text: "chunkSize", trailing: " "),
        LexemeSpec(.binaryOperator, text: "/", trailing: " "),
        LexemeSpec(.integerLiteral, text: "2"),
        LexemeSpec(.rightParen, text: ")"),
      ]
    )
    AssertLexemes(
      """
      var x: Int {
        return 0 /
               x
      }

      ///
      """,
      lexemes: [
        LexemeSpec(.keyword(.var), text: "var", trailing: " "),
        LexemeSpec(.identifier, text: "x"),
        LexemeSpec(.colon, text: ":", trailing: " "),
        LexemeSpec(.identifier, text: "Int", trailing: " "),
        LexemeSpec(.leftBrace, text: "{"),
        LexemeSpec(.keyword(.return), leading: "\n  ", text: "return", trailing: " ", flags: [.isAtStartOfLine]),
        LexemeSpec(.integerLiteral, text: "0", trailing: " "),
        LexemeSpec(.binaryOperator, text: "/"),
        LexemeSpec(.identifier, leading: "\n         ", text: "x", flags: [.isAtStartOfLine]),
        LexemeSpec(.rightBrace, leading: "\n", text: "}", flags: [.isAtStartOfLine]),
        LexemeSpec(.eof, leading: "\n\n///", text: "", flags: [.isAtStartOfLine]),
      ]
    )

    AssertLexemes(
      "n /= 2 // foo",
      lexemes: [
        LexemeSpec(.identifier, text: "n", trailing: " "),
        LexemeSpec(.binaryOperator, text: "/=", trailing: " "),
        LexemeSpec(.integerLiteral, text: "2", trailing: " // foo"),
      ]
    )

    AssertLexemes(
      "UIColor(white: 216.0/255.0, alpha: 44.0/255.0)",
      lexemes: [
        LexemeSpec(.identifier, text: "UIColor"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.identifier, text: "white"),
        LexemeSpec(.colon, text: ":", trailing: " "),
        LexemeSpec(.floatingLiteral, text: "216.0"),
        LexemeSpec(.binaryOperator, text: "/"),
        LexemeSpec(.floatingLiteral, text: "255.0"),
        LexemeSpec(.comma, text: ",", trailing: " "),
        LexemeSpec(.identifier, text: "alpha"),
        LexemeSpec(.colon, text: ":", trailing: " "),
        LexemeSpec(.floatingLiteral, text: "44.0"),
        LexemeSpec(.binaryOperator, text: "/"),
        LexemeSpec(.floatingLiteral, text: "255.0"),
        LexemeSpec(.rightParen, text: ")"),
      ]
    )

    AssertLexemes(
      "#/abc|#def/",
      lexemes: [
        LexemeSpec(.pound, text: "#"),
        LexemeSpec(.binaryOperator, text: "/"),
        LexemeSpec(.identifier, text: "abc"),
        LexemeSpec(.binaryOperator, text: "|"),
        LexemeSpec(.pound, text: "#"),
        LexemeSpec(.identifier, text: "def"),
        LexemeSpec(.postfixOperator, text: "/"),
      ]
    )
  }

  func testUnicodeReplcementsInStream() {
    AssertLexemes(
      "() -> (\u{feff})",
      lexemes: [
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.rightParen, text: ")", trailing: " "),
        LexemeSpec(.arrow, text: "->", trailing: " "),
        LexemeSpec(.leftParen, text: "(", trailing: "\u{feff}"),
        LexemeSpec(.rightParen, text: ")"),
      ]
    )

    AssertLexemes(
      "y\u{fffe} + z",
      lexemes: [
        LexemeSpec(.identifier, text: "y", trailing: "\u{fffe} "),
        LexemeSpec(.binaryOperator, text: "+", trailing: " "),
        LexemeSpec(.identifier, text: "z"),
      ]
    )
  }

  func testOperators() {
    AssertLexemes(
      """
      myString==""
      """,
      lexemes: [
        LexemeSpec(.identifier, text: "myString"),
        LexemeSpec(.binaryOperator, text: "=="),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: ""),
        LexemeSpec(.stringQuote, text: #"""#),
      ]
    )
  }

  func testEditorPlaceholders() {
    AssertLexemes(
      "!<#b1#> && !<#b2#>",
      lexemes: [
        LexemeSpec(.prefixOperator, text: "!"),
        LexemeSpec(.identifier, text: "<#b1#>", trailing: " "),
        LexemeSpec(.binaryOperator, text: "&&", trailing: " "),
        LexemeSpec(.prefixOperator, text: "!"),
        LexemeSpec(.identifier, text: "<#b2#>"),
      ]
    )

    AssertLexemes(
      "<##>",
      lexemes: [
        LexemeSpec(.identifier, text: "<##>", trailing: "")
      ]
    )
  }

  func testCommentAttribution() {
    AssertLexemes(
      """
      func foo() { // comment
          // new comment
          bar()
      }
      """,
      lexemes: [
        LexemeSpec(.keyword(.func), text: "func", trailing: " "),
        LexemeSpec(.identifier, text: "foo"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.rightParen, text: ")", trailing: " "),
        LexemeSpec(.leftBrace, text: "{", trailing: " // comment"),
        LexemeSpec(
          .identifier,
          leading: """

                // new comment
                \

            """,
          text: "bar",
          flags: [.isAtStartOfLine]
        ),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.rightParen, text: ")"),
        LexemeSpec(.rightBrace, leading: "\n", text: "}", flags: [.isAtStartOfLine]),
      ]
    )
  }

  func testCommentAttribution2() {
    // Example from https://forums.swift.org/t/changing-comment-trivia-attribution-from-trailing-trivia-to-leading-trivia/50773
    AssertLexemes(
      "/*X_START*/x/*X_END*/ + /*Y_START*/y/*Y_END*/",
      lexemes: [
        LexemeSpec(.identifier, leading: "/*X_START*/", text: "x", trailing: "/*X_END*/ "),
        LexemeSpec(.binaryOperator, text: "+", trailing: " /*Y_START*/"),
        LexemeSpec(.identifier, text: "y", trailing: "/*Y_END*/"),
      ]
    )
  }

  func testNumericLiteralDiagnostics() {
    AssertLexemes(
      " 0x1.01️⃣",
      lexemes: [LexemeSpec(.integerLiteral, leading: " ", text: "0x1.0", error: "hexadecimal floating point literal must end with an exponent")]
    )
    AssertLexemes(
      " 0x1p1️⃣_",
      lexemes: [LexemeSpec(.floatingLiteral, leading: " ", text: "0x1p_", error: "'_' is not a valid first character in floating point exponent")]
    )
    AssertLexemes(
      "01️⃣QWERTY",
      lexemes: [LexemeSpec(.integerLiteral, text: "0QWERTY", error: "'Q' is not a valid digit in integer literal")]
    )
    AssertLexemes(
      "0b1️⃣QWERTY",
      lexemes: [LexemeSpec(.integerLiteral, text: "0bQWERTY", error: "'Q' is not a valid binary digit (0 or 1) in integer literal")]
    )
    AssertLexemes(
      "0x1️⃣QWERTY",
      lexemes: [LexemeSpec(.integerLiteral, text: "0xQWERTY", error: "'Q' is not a valid hexadecimal digit (0-9, A-F) in integer literal")]
    )
    AssertLexemes(
      "0o1️⃣QWERTY",
      lexemes: [LexemeSpec(.integerLiteral, text: "0oQWERTY", error: "'Q' is not a valid octal digit (0-7) in integer literal")]
    )
    AssertLexemes(
      "1.0e+1️⃣QWERTY",
      lexemes: [LexemeSpec(.floatingLiteral, text: "1.0e+QWERTY", error: "'Q' is not a valid digit in floating point exponent")]
    )
    AssertLexemes(
      "0x1p+1️⃣QWERTY",
      lexemes: [LexemeSpec(.floatingLiteral, text: "0x1p+QWERTY", error: "'Q' is not a valid digit in floating point exponent")]
    )
  }

  func testInvalidCharacterSpanningMultipleBytes() {
    AssertLexemes(
      "121️⃣😡",
      lexemes: [
        LexemeSpec(.integerLiteral, text: "12😡", error: "'😡' is not a valid digit in integer literal")
      ]
    )
  }

  func testBadNumericLiteralDigits() {
    AssertLexemes(
      "01️⃣a1234567",
      lexemes: [LexemeSpec(.integerLiteral, text: "0a1234567", error: "'a' is not a valid digit in integer literal")]
    )
    AssertLexemes(
      "01231️⃣A5678",
      lexemes: [LexemeSpec(.integerLiteral, text: "0123A5678", error: "'A' is not a valid digit in integer literal")]
    )
    AssertLexemes(
      "0b101️⃣20101",
      lexemes: [LexemeSpec(.integerLiteral, text: "0b1020101", error: "'2' is not a valid binary digit (0 or 1) in integer literal")]
    )
    AssertLexemes(
      "0o13571️⃣864",
      lexemes: [LexemeSpec(.integerLiteral, text: "0o1357864", error: "'8' is not a valid octal digit (0-7) in integer literal")]
    )
    AssertLexemes(
      "0x147AD1️⃣G0",
      lexemes: [LexemeSpec(.integerLiteral, text: "0x147ADG0", error: "'G' is not a valid hexadecimal digit (0-9, A-F) in integer literal")]
    )
  }

  func testStringLiteralWithBlockCommentStart() {
    AssertLexemes(
      """
      "/*"
      """,
      lexemes: [
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: "/*"),
        LexemeSpec(.stringQuote, text: #"""#),
      ]
    )
  }

  func testBOMAtStartOfFile() throws {
    let sourceBytes: [UInt8] = [0xef, 0xbb, 0xbf]
    let lexemes = lex(sourceBytes)

    guard lexemes.count == 1 else {
      return XCTFail("Expected 1 lexeme, got \(lexemes.count)")
    }

    AssertRawBytesLexeme(
      lexemes[0],
      kind: .eof,
      leadingTrivia: sourceBytes,
      text: []
    )
  }

  func testBOMInTheMiddleOfIdentifier() throws {
    let sourceBytes: [UInt8] = [UInt8(ascii: "a"), 0xef, 0xbb, 0xbf, UInt8(ascii: "b")]
    let lexemes = lex(sourceBytes)

    guard lexemes.count == 2 else {
      return XCTFail("Expected 2 lexemes, got \(lexemes.count)")
    }

    AssertRawBytesLexeme(
      lexemes[0],
      kind: .identifier,
      text: sourceBytes
    )
  }

  func testBOMAsLeadingTriviaInSourceFile() throws {
    let sourceBytes: [UInt8] = [UInt8(ascii: "1"), UInt8(ascii: " "), UInt8(ascii: "+"), UInt8(ascii: " "), 0xef, 0xbb, 0xbf, UInt8(ascii: "2")]
    let lexemes = lex(sourceBytes)

    guard lexemes.count == 4 else {
      return XCTFail("Expected 4 lexemes, got \(lexemes.count)")
    }

    AssertRawBytesLexeme(
      lexemes[1],
      kind: .binaryOperator,
      text: [UInt8(ascii: "+")],
      trailingTrivia: [UInt8(ascii: " "), 0xef, 0xbb, 0xbf]
    )
  }

  func testInvalidUtf8() {
    let sourceBytes: [UInt8] = [0xef, 0xfb, 0xbd, 0x0a]

    let lexemes = lex(sourceBytes)
    guard lexemes.count == 1 else {
      return XCTFail("Expected 1 lexeme, got \(lexemes.count)")
    }
    AssertRawBytesLexeme(
      lexemes[0],
      kind: .eof,
      leadingTrivia: sourceBytes,
      text: []
    )
  }

  func testInvalidUtf8_2() {
    let sourceBytes: [UInt8] = [0xfd]

    let lexemes = lex(sourceBytes)
    guard lexemes.count == 1 else {
      return XCTFail("Expected 1 lexeme, got \(lexemes.count)")
    }
    AssertRawBytesLexeme(
      lexemes[0],
      kind: .eof,
      leadingTrivia: sourceBytes,
      text: []
    )
  }

  func testInterpolatedString() {
    AssertLexemes(
      #"""
      "\("message")"
      """#,
      lexemes: [
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: ""),
        LexemeSpec(.backslash, text: "\\"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: "message"),
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.rightParen, text: ")"),
        LexemeSpec(.stringSegment, text: ""),
        LexemeSpec(.stringQuote, text: #"""#),
      ]
    )
  }

  func testBackslashInFrontOfStringInterpolation() {
    AssertLexemes(
      #"""
      "\"\(text)"
      """#,
      lexemes: [
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: #"\""#),
        LexemeSpec(.backslash, text: "\\"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.identifier, text: "text"),
        LexemeSpec(.rightParen, text: ")"),
        LexemeSpec(.stringSegment, text: ""),
        LexemeSpec(.stringQuote, text: #"""#),
      ]
    )
  }

  func testUnterminatedSingleLineStringLiteral() {
    AssertLexemes(
      ##"""
      "bar

      """##,
      lexemes: [
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: "bar"),
        LexemeSpec(.eof, leading: "\n", text: "", flags: [.isAtStartOfLine]),
      ]
    )
  }

  func testUnclosedStringInterpolationWithNewline() {
    AssertLexemes(
      #"""
      "\(

      """#,
      lexemes: [
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: ""),
        LexemeSpec(.backslash, text: "\\"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.stringSegment, text: ""),
        LexemeSpec(.eof, leading: "\n", text: "", flags: .isAtStartOfLine),
      ]
    )
  }

  func testNewlineInInterpolationOfSingleLineString() {
    AssertLexemes(
      #"""
      "test \(label:
      foo)"
      """#,
      lexemes: [
        LexemeSpec(.stringQuote, text: #"""#),
        LexemeSpec(.stringSegment, text: "test "),
        LexemeSpec(.backslash, text: "\\"),
        LexemeSpec(.leftParen, text: "("),
        LexemeSpec(.identifier, text: "label"),
        LexemeSpec(.colon, text: ":"),
        LexemeSpec(.stringSegment, text: ""),
        LexemeSpec(.identifier, leading: "\n", text: "foo", flags: .isAtStartOfLine),
        LexemeSpec(.rightParen, text: ")"),
        LexemeSpec(.stringQuote, text: #"""#),
      ]
    )
  }

  func testMultilineStringLiteral() {
    AssertLexemes(
      #"""
        """
        line 1
        line 2
        """
      """#,
      lexemes: [
        LexemeSpec(.multilineStringQuote, leading: "  ", text: #"""""#, trailing: "\n"),
        LexemeSpec(.stringSegment, text: "  line 1\n"),
        LexemeSpec(.stringSegment, text: "  line 2\n"),
        LexemeSpec(.stringSegment, text: "  "),
        LexemeSpec(.multilineStringQuote, text: #"""""#),
      ]
    )

    AssertLexemes(
      #"""
        """
        line 1 \
        line 2
        """
      """#,
      lexemes: [
        LexemeSpec(.multilineStringQuote, leading: "  ", text: #"""""#, trailing: "\n"),
        LexemeSpec(.stringSegment, text: "  line 1 ", trailing: "\\\n"),
        LexemeSpec(.stringSegment, text: "  line 2\n"),
        LexemeSpec(.stringSegment, text: "  "),
        LexemeSpec(.multilineStringQuote, text: #"""""#),
      ]
    )
  }

  func testMultiDigitTupleAccess() {
    AssertLexemes(
      "x.13.1",
      lexemes: [
        LexemeSpec(.identifier, text: "x"),
        LexemeSpec(.period, text: "."),
        LexemeSpec(.integerLiteral, text: "13"),
        LexemeSpec(.period, text: "."),
        LexemeSpec(.integerLiteral, text: "1"),
      ]
    )
  }

  func testFloatingPointNumberAfterRangeOperator() {
    AssertLexemes(
      "0.1...0.2",
      lexemes: [
        LexemeSpec(.floatingLiteral, text: "0.1"),
        LexemeSpec(.binaryOperator, text: "..."),
        LexemeSpec(.floatingLiteral, text: "0.2"),
      ]
    )
  }

  func testUnterminatedFloatLiteral() {
    AssertLexemes(
      "0.",
      lexemes: [
        LexemeSpec(.integerLiteral, text: "0"),
        LexemeSpec(.period, text: "."),
      ]
    )
  }
}
