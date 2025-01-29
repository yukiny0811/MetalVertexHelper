//
//  VertexField.swift
//  MetalVertexHelper
//
//  Created by Yuki Kuwashima on 2025/01/29.
//

import simd

protocol VertexField {
    static var typeName: String { get }
    static var size: Int { get }
    static var alignment: AlignType { get }
}

extension VertexField {
    static func process(
        typeResultString: inout [String],
        valueResultString: inout [String],
        alignCount: Int,
        varName: String
    ) {
        typeResultString += Array(repeating: "Bool", count: alignCount)
        valueResultString += Array(repeating: "false", count: alignCount)
        typeResultString.append(typeName)
        valueResultString.append(varName)
    }
}
