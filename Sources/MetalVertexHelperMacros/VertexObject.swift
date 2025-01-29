//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//

import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import simd

public struct VertexObject: MemberMacro {
    
    private static let supportedTypes: [String] = [
        "Float",
        "simd_float2",
        "simd_float3",
        "simd_float4",
    ]
    
    private static func isSuppported(_ typeString: String) -> Bool {
        return supportedTypes.contains(typeString)
    }
    
    enum AlignType: Int, Equatable {
        case four
        case eight
        case sixteen
    }
    
    static func toCObjectString(typeStringArray: [String], variableNameArray: [String]) throws -> String {
        guard typeStringArray.count == variableNameArray.count else {
            throw "mismatch array count error"
        }
        
        var typeResultString: [String] = []
        var valueResultString: [String] = []
        var currentAlign: AlignType = .four // 4 or 8 or 16
        var currentOffset: Int = 0 // current offset (32 byte alignment)
        
        for (typeStr, varName) in zip(typeStringArray, variableNameArray) {
            switch typeStr {
            case "Float":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .four)
                typeResultString += Array(repeating: "Float", count: alignCount)
                valueResultString += Array(repeating: "0.0", count: alignCount)
                valueResultString[valueResultString.count-1] = varName
            case "simd_float2":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .eight)
                typeResultString += Array(repeating: "Float", count: alignCount)
                valueResultString += Array(repeating: "0.0", count: alignCount)
                valueResultString[valueResultString.count-2] = varName + ".x"
                valueResultString[valueResultString.count-1] = varName + ".y"
            case "simd_float3":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .sixteen)
                typeResultString += Array(repeating: "Float", count: alignCount)
                valueResultString += Array(repeating: "0.0", count: alignCount)
                valueResultString[valueResultString.count-4] = varName + ".x"
                valueResultString[valueResultString.count-3] = varName + ".y"
                valueResultString[valueResultString.count-2] = varName + ".z"
            case "simd_float4":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .sixteen)
                typeResultString += Array(repeating: "Float", count: alignCount)
                valueResultString += Array(repeating: "0.0", count: alignCount)
                valueResultString[valueResultString.count-4] = varName + ".x"
                valueResultString[valueResultString.count-3] = varName + ".y"
                valueResultString[valueResultString.count-2] = varName + ".z"
                valueResultString[valueResultString.count-1] = varName + ".w"
            default:
                throw "type error"
            }
            if currentOffset >= 16 {
                currentAlign = .four
                currentOffset = 0
            }
        }
        
        return "public var cObject: (\(typeResultString.joined(separator: ","))) { (\(valueResultString.joined(separator: ","))) }"
    }
    
    static func getAlignedCount(currentAlign: inout AlignType, currentOffset: inout Int, targetType: AlignType) throws -> Int {
        switch currentAlign {
        case .four:
            if targetType == .four {
                if currentOffset == 0 {
                    currentOffset += 4
                    currentAlign = .four
                    return 1
                }
                if currentOffset == 4 {
                    currentOffset += 4
                    currentAlign = .four
                    return 1
                }
                if currentOffset == 8 {
                    currentOffset += 4
                    currentAlign = .four
                    return 1
                }
                if currentOffset == 12 {
                    currentOffset += 4
                    currentAlign = .four
                    return 1
                }
            }
            if targetType == .eight {
                if currentOffset == 0 {
                    currentOffset += 8
                    currentAlign = .eight
                    return 2
                }
                if currentOffset == 4 {
                    currentOffset += 12
                    currentAlign = .eight
                    return 3
                }
                if currentOffset == 8 {
                    currentOffset += 8
                    currentAlign = .eight
                    return 2
                }
                if currentOffset == 12 {
                    currentOffset += 12
                    currentAlign = .eight
                    return 3
                }
            }
            if targetType == .sixteen {
                if currentOffset == 0 {
                    currentOffset += 16
                    currentAlign = .sixteen
                    return 4
                }
                if currentOffset == 4 {
                    currentOffset += 28
                    currentAlign = .sixteen
                    return 7
                }
                if currentOffset == 8 {
                    currentOffset += 24
                    currentAlign = .sixteen
                    return 6
                }
                if currentOffset == 12 {
                    currentOffset += 20
                    currentAlign = .sixteen
                    return 5
                }
            }
        case .eight:
            if targetType == .four {
                if currentOffset == 0 {
                    currentOffset += 4
                    currentAlign = .eight
                    return 1
                }
                if currentOffset == 4 {
                    currentOffset += 4
                    currentAlign = .eight
                    return 1
                }
                if currentOffset == 8 {
                    currentOffset += 4
                    currentAlign = .eight
                    return 1
                }
                if currentOffset == 12 {
                    currentOffset += 4
                    currentAlign = .eight
                    return 1
                }
            }
            if targetType == .eight {
                if currentOffset == 0 {
                    currentOffset += 8
                    currentAlign = .eight
                    return 2
                }
                if currentOffset == 4 {
                    currentOffset += 12
                    currentAlign = .eight
                    return 3
                }
                if currentOffset == 8 {
                    currentOffset += 8
                    currentAlign = .eight
                    return 2
                }
                if currentOffset == 12 {
                    currentOffset += 12
                    currentAlign = .eight
                    return 3
                }
            }
            if targetType == .sixteen {
                if currentOffset == 0 {
                    currentOffset += 16
                    currentAlign = .sixteen
                    return 4
                }
                if currentOffset == 4 {
                    currentOffset += 28
                    currentAlign = .sixteen
                    return 7
                }
                if currentOffset == 8 {
                    currentOffset += 24
                    currentAlign = .sixteen
                    return 6
                }
                if currentOffset == 12 {
                    currentOffset += 20
                    currentAlign = .sixteen
                    return 5
                }
            }
        case .sixteen:
            break
        }
        throw "align error"
    }
    
    static func toVertexDescriptorString(typeStringArray: [String]) throws -> String {
        var resultString: String = ""
        resultString += "let descriptor = MTLVertexDescriptor()"
        
        var attributeIndex: Int = 0
        var totalOffset: Int = 0
        
        var currentAlign: AlignType = .four // 4 or 8 or 16
        var currentOffset: Int = 0 // current offset (32 byte alignment)
        
        for typeStr in typeStringArray {
            switch typeStr {
            case "Float":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .four)
                resultString += "descriptor.attributes[\(attributeIndex)].format = .float" + "\n"
                resultString += "descriptor.attributes[\(attributeIndex)].offset = \(totalOffset)" + "\n"
                resultString += "descriptor.attributes[\(attributeIndex)].bufferIndex = 0" + "\n"
                totalOffset += alignCount * 4
            case "simd_float2":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .eight)
                resultString += "descriptor.attributes[\(attributeIndex)].format = .float2" + "\n"
                resultString += "descriptor.attributes[\(attributeIndex)].offset = \(totalOffset)" + "\n"
                resultString += "descriptor.attributes[\(attributeIndex)].bufferIndex = 0" + "\n"
                totalOffset += alignCount * 4
            case "simd_float3":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .sixteen)
                resultString += "descriptor.attributes[\(attributeIndex)].format = .float3" + "\n"
                resultString += "descriptor.attributes[\(attributeIndex)].offset = \(totalOffset)" + "\n"
                resultString += "descriptor.attributes[\(attributeIndex)].bufferIndex = 0" + "\n"
                totalOffset += alignCount * 4
            case "simd_float4":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .sixteen)
                resultString += "descriptor.attributes[\(attributeIndex)].format = .float4" + "\n"
                resultString += "descriptor.attributes[\(attributeIndex)].offset = \(totalOffset)" + "\n"
                resultString += "descriptor.attributes[\(attributeIndex)].bufferIndex = 0" + "\n"
                totalOffset += alignCount * 4
            default:
                break
            }
            attributeIndex += 1
            if currentOffset >= 16 {
                currentAlign = .four
                currentOffset = 0
            }
        }
        
        resultString += "descriptor.layouts[0].stride = \(totalOffset)" + "\n"
        resultString += "descriptor.layouts[0].stepRate = 1" + "\n"
        resultString += "descriptor.layouts[0].stepFunction = .perVertex" + "\n"
        resultString += "return descriptor" + "\n"
        
        return "public static func generateVertexDescriptor() -> MTLVertexDescriptor {\n" + resultString + "}"
    }
    
    static func getMemorySize(typeStringArray: [String]) throws -> Int {
        
        var totalOffset: Int = 0
        
        var currentAlign: AlignType = .four // 4 or 8 or 16
        var currentOffset: Int = 0 // current offset (32 byte alignment)
        
        for typeStr in typeStringArray {
            switch typeStr {
            case "Float":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .four)
                totalOffset += alignCount * 4
            case "simd_float2":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .eight)
                totalOffset += alignCount * 4
            case "simd_float3":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .sixteen)
                totalOffset += alignCount * 4
            case "simd_float4":
                let alignCount = try getAlignedCount(currentAlign: &currentAlign, currentOffset: &currentOffset, targetType: .sixteen)
                totalOffset += alignCount * 4
            default:
                break
            }
            if currentOffset >= 16 {
                currentAlign = .four
                currentOffset = 0
            }
        }
        
        return totalOffset
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        var typeStringArray: [String] = []
        var variableNameArray: [String] = []
        for member in declaration.memberBlock.members {
            guard let variable = member.decl.as(VariableDeclSyntax.self) else {
                continue
            }
            guard let firstBinding = variable.bindings.first else {
                continue
            }
            let variableName = firstBinding.pattern.trimmedDescription
            guard let typeString = firstBinding.typeAnnotation?.type.trimmedDescription else {
                continue
            }
            guard isSuppported(typeString) else {
                continue
            }
            typeStringArray.append(typeString)
            variableNameArray.append(variableName)
        }
        
        let compiledObjectString = try toCObjectString(typeStringArray: typeStringArray, variableNameArray: variableNameArray)
        let compiledDescriptorString = try toVertexDescriptorString(typeStringArray: typeStringArray)
        let memorySize = try getMemorySize(typeStringArray: typeStringArray)
        return [
            DeclSyntax(stringLiteral: compiledObjectString),
            DeclSyntax(stringLiteral: compiledDescriptorString),
            DeclSyntax(stringLiteral: "public static var memorySize: Int { \(memorySize) }")
        ]
    }
}
