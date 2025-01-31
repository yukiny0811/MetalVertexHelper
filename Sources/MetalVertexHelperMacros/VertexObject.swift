//
//  VertexObject.swift
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
    
    static func toCObjectString(
        typeStringArray: [String],
        variableNameArray: [String]
    ) throws -> String {
        guard typeStringArray.count == variableNameArray.count else {
            throw MetalVertexHelperMacroError.failed(description: "mismatch array count error")
        }
        var typeResultString: [String] = []
        var valueResultString: [String] = []
        var currentOffset: Int = 0
        var structAlignment: Int = 1
        
        for (typeStr, varName) in zip(typeStringArray, variableNameArray) {
            guard let field = SupportedTypes.all.first(where: { $0.typeName == typeStr }) else {
                throw MetalVertexHelperMacroError.failed(description: "type \(typeStr) is not supported")
            }
            
            let fieldAlign = field.alignment.rawValue
            let fieldSize  = field.size
            
            let padCount = (fieldAlign - (currentOffset % fieldAlign)) % fieldAlign
            for _ in 0..<padCount {
                typeResultString.append("Bool")
                valueResultString.append("false")
            }
            currentOffset += padCount
            
            let swiftCType = typeStr
            typeResultString.append(swiftCType)
            valueResultString.append(varName)
            
            currentOffset += fieldSize
            
            if fieldAlign > structAlignment {
                structAlignment = fieldAlign
            }
        }
        
        let finalPadCount = (structAlignment - (currentOffset % structAlignment)) % structAlignment
        for _ in 0..<finalPadCount {
            typeResultString.append("Bool")
            valueResultString.append("false")
        }
        currentOffset += finalPadCount
        
        let typeString = typeResultString.joined(separator: ",")
        let valueString = valueResultString.joined(separator: ",")
        return "public var cObject: (\(typeString)) { (\(valueString)) }"
    }
    
    private static func getVertexFormatInfo(for typeStr: String) -> (format: String, size: Int, alignment: Int, floatCount: Int) {
        switch typeStr {
        case "Float":
            return (".float", 4, 4, 1)
        case "simd_float2":
            return (".float2", 8, 8, 2)
        case "simd_float3":
            return (".float3", 16, 16, 3)
        case "simd_float4":
            return (".float4", 16, 16, 4)
        default:
            return (".invalid",  0,  1,  0)
        }
    }

    static func toVertexDescriptorString(typeStringArray: [String]) -> String {
        var result = ""
        result += "public static func generateVertexDescriptor() -> MTLVertexDescriptor {\n"
        result += "    let descriptor = MTLVertexDescriptor()\n\n"
        
        var offset = 0
        var attributeIndex = 0
        
        for typeStr in typeStringArray {
            let info = getVertexFormatInfo(for: typeStr)
            if info.format == ".invalid" {
                result += "    // Unsupported type: \(typeStr)\n"
                continue
            }
            offset = roundUp(offset, to: info.alignment)
            
            result += "    descriptor.attributes[\(attributeIndex)].format = \(info.format)\n"
            result += "    descriptor.attributes[\(attributeIndex)].offset = \(offset)\n"
            result += "    descriptor.attributes[\(attributeIndex)].bufferIndex = 0\n\n"
            
            offset += info.size
            
            attributeIndex += 1
        }
        
        let finalStride = roundUp(offset, to: 16)
        
        result += "    descriptor.layouts[0].stride = \(finalStride)\n"
        result += "    descriptor.layouts[0].stepRate = 1\n"
        result += "    descriptor.layouts[0].stepFunction = .perVertex\n\n"
        result += "    return descriptor\n"
        result += "}"
        
        return result
    }

    private static func roundUp(_ offset: Int, to alignment: Int) -> Int {
        let remainder = offset % alignment
        return remainder == 0 ? offset : (offset + (alignment - remainder))
    }

    static func getMemorySize(typeStringArray: [String], structAlign: AlignType) throws -> Int {
        var currentOffset = 0

        for typeStr in typeStringArray {
            guard let field = SupportedTypes.all.first(where: { $0.typeName == typeStr }) else {
                throw MetalVertexHelperMacroError.failed(description: "type \(typeStr) is not supported")
            }
            currentOffset = roundUp(currentOffset, to: field.alignment.rawValue)
            currentOffset += field.size
        }
        currentOffset = roundUp(currentOffset, to: structAlign.rawValue)
        return currentOffset
    }
    
    static func calculateStructAlignment(typeStringArray: [String]) throws -> AlignType {
        var largestAlign = AlignType.one
        for type in typeStringArray {
            guard let field = SupportedTypes.all.first(where: { $0.typeName == type }) else {
                throw MetalVertexHelperMacroError.failed(description: "type \(type) is not supported")
            }
            largestAlign = max(field.alignment, largestAlign)
        }
        return largestAlign
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
            typeStringArray.append(typeString)
            variableNameArray.append(variableName)
        }
        
        let structAlign = try calculateStructAlignment(typeStringArray: typeStringArray)
        
        let compiledObjectString = try toCObjectString(typeStringArray: typeStringArray, variableNameArray: variableNameArray)
        let compiledDescriptorString = toVertexDescriptorString(typeStringArray: typeStringArray)
        let memorySize = try getMemorySize(typeStringArray: typeStringArray, structAlign: structAlign)
        return [
            DeclSyntax(stringLiteral: compiledObjectString),
            DeclSyntax(stringLiteral: compiledDescriptorString),
            DeclSyntax(stringLiteral: "public static var memorySize: Int { \(memorySize) }")
        ]
    }
}
