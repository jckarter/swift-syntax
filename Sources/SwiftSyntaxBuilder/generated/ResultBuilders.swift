//// Automatically generated by generate-swift-syntax
//// Do not edit directly!
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#if swift(>=6)
@_spi(ExperimentalLanguageFeatures) public import SwiftSyntax
#else
@_spi(ExperimentalLanguageFeatures) import SwiftSyntax
#endif

// MARK: - AccessorDeclListBuilder

@resultBuilder
public struct AccessorDeclListBuilder: ListBuilder {
  public typealias FinalResult = AccessorDeclListSyntax
}

extension AccessorDeclListSyntax {
  public init(@AccessorDeclListBuilder itemsBuilder: () throws -> AccessorDeclListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - ArrayElementListBuilder

@resultBuilder
public struct ArrayElementListBuilder: ListBuilder {
  public typealias FinalResult = ArrayElementListSyntax
}

extension ArrayElementListSyntax {
  public init(@ArrayElementListBuilder itemsBuilder: () throws -> ArrayElementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - AttributeListBuilder

@resultBuilder
public struct AttributeListBuilder: ListBuilder {
  public typealias FinalResult = AttributeListSyntax
  
  public static func buildExpression(_ expression: AttributeSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  public static func buildExpression(_ expression: IfConfigDeclSyntax) -> Component {
    buildExpression(.init(expression))
  }
}

extension AttributeListSyntax {
  public init(@AttributeListBuilder itemsBuilder: () throws -> AttributeListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - AvailabilityArgumentListBuilder

@resultBuilder
public struct AvailabilityArgumentListBuilder: ListBuilder {
  public typealias FinalResult = AvailabilityArgumentListSyntax
}

extension AvailabilityArgumentListSyntax {
  public init(@AvailabilityArgumentListBuilder itemsBuilder: () throws -> AvailabilityArgumentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - CatchClauseListBuilder

@resultBuilder
public struct CatchClauseListBuilder: ListBuilder {
  public typealias FinalResult = CatchClauseListSyntax
}

extension CatchClauseListSyntax {
  public init(@CatchClauseListBuilder itemsBuilder: () throws -> CatchClauseListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - CatchItemListBuilder

@resultBuilder
public struct CatchItemListBuilder: ListBuilder {
  public typealias FinalResult = CatchItemListSyntax
}

extension CatchItemListSyntax {
  public init(@CatchItemListBuilder itemsBuilder: () throws -> CatchItemListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - ClosureCaptureListBuilder

@resultBuilder
public struct ClosureCaptureListBuilder: ListBuilder {
  public typealias FinalResult = ClosureCaptureListSyntax
}

extension ClosureCaptureListSyntax {
  public init(@ClosureCaptureListBuilder itemsBuilder: () throws -> ClosureCaptureListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - ClosureParameterListBuilder

@resultBuilder
public struct ClosureParameterListBuilder: ListBuilder {
  public typealias FinalResult = ClosureParameterListSyntax
}

extension ClosureParameterListSyntax {
  public init(@ClosureParameterListBuilder itemsBuilder: () throws -> ClosureParameterListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - ClosureShorthandParameterListBuilder

@resultBuilder
public struct ClosureShorthandParameterListBuilder: ListBuilder {
  public typealias FinalResult = ClosureShorthandParameterListSyntax
}

extension ClosureShorthandParameterListSyntax {
  public init(@ClosureShorthandParameterListBuilder itemsBuilder: () throws -> ClosureShorthandParameterListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - CodeBlockItemListBuilder

@resultBuilder
public struct CodeBlockItemListBuilder: ListBuilder {
  public typealias FinalResult = CodeBlockItemListSyntax
}

extension CodeBlockItemListSyntax {
  public init(@CodeBlockItemListBuilder itemsBuilder: () throws -> CodeBlockItemListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - CompositionTypeElementListBuilder

@resultBuilder
public struct CompositionTypeElementListBuilder: ListBuilder {
  public typealias FinalResult = CompositionTypeElementListSyntax
}

extension CompositionTypeElementListSyntax {
  public init(@CompositionTypeElementListBuilder itemsBuilder: () throws -> CompositionTypeElementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - ConditionElementListBuilder

@resultBuilder
public struct ConditionElementListBuilder: ListBuilder {
  public typealias FinalResult = ConditionElementListSyntax
}

extension ConditionElementListSyntax {
  public init(@ConditionElementListBuilder itemsBuilder: () throws -> ConditionElementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - DeclModifierListBuilder

@resultBuilder
public struct DeclModifierListBuilder: ListBuilder {
  public typealias FinalResult = DeclModifierListSyntax
}

extension DeclModifierListSyntax {
  public init(@DeclModifierListBuilder itemsBuilder: () throws -> DeclModifierListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - DeclNameArgumentListBuilder

@resultBuilder
public struct DeclNameArgumentListBuilder: ListBuilder {
  public typealias FinalResult = DeclNameArgumentListSyntax
}

extension DeclNameArgumentListSyntax {
  public init(@DeclNameArgumentListBuilder itemsBuilder: () throws -> DeclNameArgumentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - DesignatedTypeListBuilder

@resultBuilder
public struct DesignatedTypeListBuilder: ListBuilder {
  public typealias FinalResult = DesignatedTypeListSyntax
}

extension DesignatedTypeListSyntax {
  public init(@DesignatedTypeListBuilder itemsBuilder: () throws -> DesignatedTypeListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - DictionaryElementListBuilder

@resultBuilder
public struct DictionaryElementListBuilder: ListBuilder {
  public typealias FinalResult = DictionaryElementListSyntax
}

extension DictionaryElementListSyntax {
  public init(@DictionaryElementListBuilder itemsBuilder: () throws -> DictionaryElementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - DifferentiabilityArgumentListBuilder

@resultBuilder
public struct DifferentiabilityArgumentListBuilder: ListBuilder {
  public typealias FinalResult = DifferentiabilityArgumentListSyntax
}

extension DifferentiabilityArgumentListSyntax {
  public init(@DifferentiabilityArgumentListBuilder itemsBuilder: () throws -> DifferentiabilityArgumentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - DocumentationAttributeArgumentListBuilder

@resultBuilder
public struct DocumentationAttributeArgumentListBuilder: ListBuilder {
  public typealias FinalResult = DocumentationAttributeArgumentListSyntax
}

extension DocumentationAttributeArgumentListSyntax {
  public init(@DocumentationAttributeArgumentListBuilder itemsBuilder: () throws -> DocumentationAttributeArgumentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - EffectsAttributeArgumentListBuilder

@resultBuilder
public struct EffectsAttributeArgumentListBuilder: ListBuilder {
  public typealias FinalResult = EffectsAttributeArgumentListSyntax
}

extension EffectsAttributeArgumentListSyntax {
  public init(@EffectsAttributeArgumentListBuilder itemsBuilder: () throws -> EffectsAttributeArgumentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - EnumCaseElementListBuilder

@resultBuilder
public struct EnumCaseElementListBuilder: ListBuilder {
  public typealias FinalResult = EnumCaseElementListSyntax
}

extension EnumCaseElementListSyntax {
  public init(@EnumCaseElementListBuilder itemsBuilder: () throws -> EnumCaseElementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - EnumCaseParameterListBuilder

@resultBuilder
public struct EnumCaseParameterListBuilder: ListBuilder {
  public typealias FinalResult = EnumCaseParameterListSyntax
}

extension EnumCaseParameterListSyntax {
  public init(@EnumCaseParameterListBuilder itemsBuilder: () throws -> EnumCaseParameterListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - ExprListBuilder

@resultBuilder
public struct ExprListBuilder: ListBuilder {
  public typealias FinalResult = ExprListSyntax
}

extension ExprListSyntax {
  public init(@ExprListBuilder itemsBuilder: () throws -> ExprListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - FunctionParameterListBuilder

@resultBuilder
public struct FunctionParameterListBuilder: ListBuilder {
  public typealias FinalResult = FunctionParameterListSyntax
}

extension FunctionParameterListSyntax {
  public init(@FunctionParameterListBuilder itemsBuilder: () throws -> FunctionParameterListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - GenericArgumentListBuilder

@resultBuilder
public struct GenericArgumentListBuilder: ListBuilder {
  public typealias FinalResult = GenericArgumentListSyntax
}

extension GenericArgumentListSyntax {
  public init(@GenericArgumentListBuilder itemsBuilder: () throws -> GenericArgumentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - GenericParameterListBuilder

@resultBuilder
public struct GenericParameterListBuilder: ListBuilder {
  public typealias FinalResult = GenericParameterListSyntax
}

extension GenericParameterListSyntax {
  public init(@GenericParameterListBuilder itemsBuilder: () throws -> GenericParameterListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - GenericRequirementListBuilder

@resultBuilder
public struct GenericRequirementListBuilder: ListBuilder {
  public typealias FinalResult = GenericRequirementListSyntax
}

extension GenericRequirementListSyntax {
  public init(@GenericRequirementListBuilder itemsBuilder: () throws -> GenericRequirementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - IfConfigClauseListBuilder

@resultBuilder
public struct IfConfigClauseListBuilder: ListBuilder {
  public typealias FinalResult = IfConfigClauseListSyntax
}

extension IfConfigClauseListSyntax {
  public init(@IfConfigClauseListBuilder itemsBuilder: () throws -> IfConfigClauseListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - ImportPathComponentListBuilder

@resultBuilder
public struct ImportPathComponentListBuilder: ListBuilder {
  public typealias FinalResult = ImportPathComponentListSyntax
}

extension ImportPathComponentListSyntax {
  public init(@ImportPathComponentListBuilder itemsBuilder: () throws -> ImportPathComponentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - InheritedTypeListBuilder

@resultBuilder
public struct InheritedTypeListBuilder: ListBuilder {
  public typealias FinalResult = InheritedTypeListSyntax
}

extension InheritedTypeListSyntax {
  public init(@InheritedTypeListBuilder itemsBuilder: () throws -> InheritedTypeListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - KeyPathComponentListBuilder

@resultBuilder
public struct KeyPathComponentListBuilder: ListBuilder {
  public typealias FinalResult = KeyPathComponentListSyntax
}

extension KeyPathComponentListSyntax {
  public init(@KeyPathComponentListBuilder itemsBuilder: () throws -> KeyPathComponentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - LabeledExprListBuilder

@resultBuilder
public struct LabeledExprListBuilder: ListBuilder {
  public typealias FinalResult = LabeledExprListSyntax
}

extension LabeledExprListSyntax {
  public init(@LabeledExprListBuilder itemsBuilder: () throws -> LabeledExprListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - LifetimeSpecifierArgumentListBuilder

#if compiler(>=5.8)
@_spi(ExperimentalLanguageFeatures)
#endif
@resultBuilder
public struct LifetimeSpecifierArgumentListBuilder: ListBuilder {
  public typealias FinalResult = LifetimeSpecifierArgumentListSyntax
}

extension LifetimeSpecifierArgumentListSyntax {
  public init(@LifetimeSpecifierArgumentListBuilder itemsBuilder: () throws -> LifetimeSpecifierArgumentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - MemberBlockItemListBuilder

@resultBuilder
public struct MemberBlockItemListBuilder: ListBuilder {
  public typealias FinalResult = MemberBlockItemListSyntax
}

extension MemberBlockItemListSyntax {
  public init(@MemberBlockItemListBuilder itemsBuilder: () throws -> MemberBlockItemListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - MultipleTrailingClosureElementListBuilder

@resultBuilder
public struct MultipleTrailingClosureElementListBuilder: ListBuilder {
  public typealias FinalResult = MultipleTrailingClosureElementListSyntax
}

extension MultipleTrailingClosureElementListSyntax {
  public init(@MultipleTrailingClosureElementListBuilder itemsBuilder: () throws -> MultipleTrailingClosureElementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - ObjCSelectorPieceListBuilder

@resultBuilder
public struct ObjCSelectorPieceListBuilder: ListBuilder {
  public typealias FinalResult = ObjCSelectorPieceListSyntax
}

extension ObjCSelectorPieceListSyntax {
  public init(@ObjCSelectorPieceListBuilder itemsBuilder: () throws -> ObjCSelectorPieceListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - PatternBindingListBuilder

@resultBuilder
public struct PatternBindingListBuilder: ListBuilder {
  public typealias FinalResult = PatternBindingListSyntax
}

extension PatternBindingListSyntax {
  public init(@PatternBindingListBuilder itemsBuilder: () throws -> PatternBindingListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - PlatformVersionItemListBuilder

@resultBuilder
public struct PlatformVersionItemListBuilder: ListBuilder {
  public typealias FinalResult = PlatformVersionItemListSyntax
}

extension PlatformVersionItemListSyntax {
  public init(@PlatformVersionItemListBuilder itemsBuilder: () throws -> PlatformVersionItemListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - PrecedenceGroupAttributeListBuilder

@resultBuilder
public struct PrecedenceGroupAttributeListBuilder: ListBuilder {
  public typealias FinalResult = PrecedenceGroupAttributeListSyntax
  
  public static func buildExpression(_ expression: PrecedenceGroupRelationSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  public static func buildExpression(_ expression: PrecedenceGroupAssignmentSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  public static func buildExpression(_ expression: PrecedenceGroupAssociativitySyntax) -> Component {
    buildExpression(.init(expression))
  }
}

extension PrecedenceGroupAttributeListSyntax {
  public init(@PrecedenceGroupAttributeListBuilder itemsBuilder: () throws -> PrecedenceGroupAttributeListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - PrecedenceGroupNameListBuilder

@resultBuilder
public struct PrecedenceGroupNameListBuilder: ListBuilder {
  public typealias FinalResult = PrecedenceGroupNameListSyntax
}

extension PrecedenceGroupNameListSyntax {
  public init(@PrecedenceGroupNameListBuilder itemsBuilder: () throws -> PrecedenceGroupNameListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - PrimaryAssociatedTypeListBuilder

@resultBuilder
public struct PrimaryAssociatedTypeListBuilder: ListBuilder {
  public typealias FinalResult = PrimaryAssociatedTypeListSyntax
}

extension PrimaryAssociatedTypeListSyntax {
  public init(@PrimaryAssociatedTypeListBuilder itemsBuilder: () throws -> PrimaryAssociatedTypeListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - SimpleStringLiteralSegmentListBuilder

@resultBuilder
public struct SimpleStringLiteralSegmentListBuilder: ListBuilder {
  public typealias FinalResult = SimpleStringLiteralSegmentListSyntax
}

extension SimpleStringLiteralSegmentListSyntax {
  public init(@SimpleStringLiteralSegmentListBuilder itemsBuilder: () throws -> SimpleStringLiteralSegmentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - SpecializeAttributeArgumentListBuilder

@resultBuilder
public struct SpecializeAttributeArgumentListBuilder: ListBuilder {
  public typealias FinalResult = SpecializeAttributeArgumentListSyntax
  
  public static func buildExpression(_ expression: LabeledSpecializeArgumentSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  public static func buildExpression(_ expression: SpecializeAvailabilityArgumentSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  public static func buildExpression(_ expression: SpecializeTargetFunctionArgumentSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  public static func buildExpression(_ expression: GenericWhereClauseSyntax) -> Component {
    buildExpression(.init(expression))
  }
}

extension SpecializeAttributeArgumentListSyntax {
  public init(@SpecializeAttributeArgumentListBuilder itemsBuilder: () throws -> SpecializeAttributeArgumentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - StringLiteralSegmentListBuilder

@resultBuilder
public struct StringLiteralSegmentListBuilder: ListBuilder {
  public typealias FinalResult = StringLiteralSegmentListSyntax
  
  public static func buildExpression(_ expression: StringSegmentSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  public static func buildExpression(_ expression: ExpressionSegmentSyntax) -> Component {
    buildExpression(.init(expression))
  }
}

extension StringLiteralSegmentListSyntax {
  public init(@StringLiteralSegmentListBuilder itemsBuilder: () throws -> StringLiteralSegmentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - SwitchCaseItemListBuilder

@resultBuilder
public struct SwitchCaseItemListBuilder: ListBuilder {
  public typealias FinalResult = SwitchCaseItemListSyntax
}

extension SwitchCaseItemListSyntax {
  public init(@SwitchCaseItemListBuilder itemsBuilder: () throws -> SwitchCaseItemListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - SwitchCaseListBuilder

@resultBuilder
public struct SwitchCaseListBuilder: ListBuilder {
  public typealias FinalResult = SwitchCaseListSyntax
  
  public static func buildExpression(_ expression: SwitchCaseSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  public static func buildExpression(_ expression: IfConfigDeclSyntax) -> Component {
    buildExpression(.init(expression))
  }
}

extension SwitchCaseListSyntax {
  public init(@SwitchCaseListBuilder itemsBuilder: () throws -> SwitchCaseListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - TuplePatternElementListBuilder

@resultBuilder
public struct TuplePatternElementListBuilder: ListBuilder {
  public typealias FinalResult = TuplePatternElementListSyntax
}

extension TuplePatternElementListSyntax {
  public init(@TuplePatternElementListBuilder itemsBuilder: () throws -> TuplePatternElementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - TupleTypeElementListBuilder

@resultBuilder
public struct TupleTypeElementListBuilder: ListBuilder {
  public typealias FinalResult = TupleTypeElementListSyntax
}

extension TupleTypeElementListSyntax {
  public init(@TupleTypeElementListBuilder itemsBuilder: () throws -> TupleTypeElementListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - TypeSpecifierListBuilder

@resultBuilder
public struct TypeSpecifierListBuilder: ListBuilder {
  public typealias FinalResult = TypeSpecifierListSyntax
  
  public static func buildExpression(_ expression: SimpleTypeSpecifierSyntax) -> Component {
    buildExpression(.init(expression))
  }
  
  #if compiler(>=5.8)
  @_spi(ExperimentalLanguageFeatures)
  #endif
  public static func buildExpression(_ expression: LifetimeTypeSpecifierSyntax) -> Component {
    buildExpression(.init(expression))
  }
}

extension TypeSpecifierListSyntax {
  public init(@TypeSpecifierListBuilder itemsBuilder: () throws -> TypeSpecifierListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - UnexpectedNodesBuilder

@resultBuilder
public struct UnexpectedNodesBuilder: ListBuilder {
  public typealias FinalResult = UnexpectedNodesSyntax
}

extension UnexpectedNodesSyntax {
  public init(@UnexpectedNodesBuilder itemsBuilder: () throws -> UnexpectedNodesSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - VersionComponentListBuilder

@resultBuilder
public struct VersionComponentListBuilder: ListBuilder {
  public typealias FinalResult = VersionComponentListSyntax
}

extension VersionComponentListSyntax {
  public init(@VersionComponentListBuilder itemsBuilder: () throws -> VersionComponentListSyntax) rethrows {
    self = try itemsBuilder()
  }
}

// MARK: - YieldedExpressionListBuilder

@resultBuilder
public struct YieldedExpressionListBuilder: ListBuilder {
  public typealias FinalResult = YieldedExpressionListSyntax
}

extension YieldedExpressionListSyntax {
  public init(@YieldedExpressionListBuilder itemsBuilder: () throws -> YieldedExpressionListSyntax) rethrows {
    self = try itemsBuilder()
  }
}
