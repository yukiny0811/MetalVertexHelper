//
//  Fields.swift
//  MetalVertexHelper
//
//  Created by Yuki Kuwashima on 2025/01/29.
//

import Foundation

public enum Field_Bool: VertexField {
    static let typeName: String = "Bool"
    static let size: Int = 1
    static let alignment: AlignType = .one
}

public enum Field_Char: VertexField {
    static let typeName: String = "Int8"
    static let size: Int = 1
    static let alignment: AlignType = .one
}

public enum Field_UChar: VertexField {
    static let typeName: String = "UInt8"
    static let size: Int = 1
    static let alignment: AlignType = .one
}

public enum Field_Short: VertexField {
    static let typeName: String = "Int16"
    static let size: Int = 2
    static let alignment: AlignType = .two
}

public enum Field_UShort: VertexField {
    static let typeName: String = "UInt16"
    static let size: Int = 2
    static let alignment: AlignType = .two
}

public enum Field_Int: VertexField {
    static let typeName: String = "Int32"
    static let size: Int = 4
    static let alignment: AlignType = .four
}

public enum Field_UInt: VertexField {
    static let typeName: String = "UInt32"
    static let size: Int = 4
    static let alignment: AlignType = .four
}

public enum Field_Long: VertexField {
    static let typeName: String = "Int"
    static let size: Int = 8
    static let alignment: AlignType = .eight
}

public enum Field_Half: VertexField {
    static let typeName: String = "Float16"
    static let size: Int = 2
    static let alignment: AlignType = .two
}

public enum Field_Float: VertexField {
    static let typeName: String = "Float"
    static let size: Int = 4
    static let alignment: AlignType = .four
}

// Int Types
public enum Field_Int2: VertexField {
    static let typeName: String = "simd_int2"
    static let size: Int = 8
    static let alignment: AlignType = .eight
}

public enum Field_UInt2: VertexField {
    static let typeName: String = "simd_uint2"
    static let size: Int = 8
    static let alignment: AlignType = .eight
}

public enum Field_Int3: VertexField {
    static let typeName: String = "simd_int3"
    static let size: Int = 16
    static let alignment: AlignType = .sixteen
}

public enum Field_UInt3: VertexField {
    static let typeName: String = "simd_uint3"
    static let size: Int = 16
    static let alignment: AlignType = .sixteen
}

public enum Field_Int4: VertexField {
    static let typeName: String = "simd_int4"
    static let size: Int = 16
    static let alignment: AlignType = .sixteen
}

public enum Field_UInt4: VertexField {
    static let typeName: String = "simd_uint4"
    static let size: Int = 16
    static let alignment: AlignType = .sixteen
}

public enum Field_Float2: VertexField {
    static let typeName: String = "simd_float2"
    static let size: Int = 8
    static let alignment: AlignType = .eight
}

public enum Field_Float3: VertexField {
    static let typeName: String = "simd_float3"
    static let size: Int = 16
    static let alignment: AlignType = .sixteen
}

public enum Field_Float4: VertexField {
    static let typeName: String = "simd_float4"
    static let size: Int = 16
    static let alignment: AlignType = .sixteen
}

// MARK: - Half Types
public enum Field_Half2: VertexField {
    static let typeName: String = "simd_half2"
    static let size: Int = 4
    static let alignment: AlignType = .four
}

public enum Field_Half3: VertexField {
    static let typeName: String = "simd_half3"
    static let size: Int = 8
    static let alignment: AlignType = .eight
}

public enum Field_Half4: VertexField {
    static let typeName: String = "simd_half4"
    static let size: Int = 8
    static let alignment: AlignType = .eight
}

public enum Field_Half2x2: VertexField {
    static let typeName: String = "simd_half2x2"
    static let size: Int = 8
    static let alignment: AlignType = .four
}

public enum Field_Half2x3: VertexField {
    static let typeName: String = "simd_half2x3"
    static let size: Int = 16
    static let alignment: AlignType = .eight
}

public enum Field_Half2x4: VertexField {
    static let typeName: String = "simd_half2x4"
    static let size: Int = 16
    static let alignment: AlignType = .eight
}

public enum Field_Half3x2: VertexField {
    static let typeName: String = "simd_half3x2"
    static let size: Int = 12
    static let alignment: AlignType = .four
}

public enum Field_Half3x3: VertexField {
    static let typeName: String = "simd_half3x3"
    static let size: Int = 24
    static let alignment: AlignType = .eight
}

public enum Field_Half3x4: VertexField {
    static let typeName: String = "simd_half3x4"
    static let size: Int = 24
    static let alignment: AlignType = .eight
}

public enum Field_Half4x2: VertexField {
    static let typeName: String = "simd_half4x2"
    static let size: Int = 16
    static let alignment: AlignType = .four
}

public enum Field_Half4x3: VertexField {
    static let typeName: String = "simd_half4x3"
    static let size: Int = 32
    static let alignment: AlignType = .eight
}

public enum Field_Half4x4: VertexField {
    static let typeName: String = "simd_half4x4"
    static let size: Int = 32
    static let alignment: AlignType = .eight
}

// MARK: - Float Matrix Types
public enum Field_Float2x2: VertexField {
    static let typeName: String = "simd_float2x2"
    static let size: Int = 16
    static let alignment: AlignType = .eight
}

public enum Field_Float2x3: VertexField {
    static let typeName: String = "simd_float2x3"
    static let size: Int = 32
    static let alignment: AlignType = .sixteen
}

public enum Field_Float2x4: VertexField {
    static let typeName: String = "simd_float2x4"
    static let size: Int = 32
    static let alignment: AlignType = .sixteen
}

public enum Field_Float3x2: VertexField {
    static let typeName: String = "simd_float3x2"
    static let size: Int = 24
    static let alignment: AlignType = .eight
}

public enum Field_Float3x3: VertexField {
    static let typeName: String = "simd_float3x3"
    static let size: Int = 48
    static let alignment: AlignType = .sixteen
}

public enum Field_Float3x4: VertexField {
    static let typeName: String = "simd_float3x4"
    static let size: Int = 48
    static let alignment: AlignType = .sixteen
}

public enum Field_Float4x2: VertexField {
    static let typeName: String = "simd_float4x2"
    static let size: Int = 32
    static let alignment: AlignType = .eight
}

public enum Field_Float4x3: VertexField {
    static let typeName: String = "simd_float4x3"
    static let size: Int = 64
    static let alignment: AlignType = .sixteen
}

public enum Field_Float4x4: VertexField {
    static let typeName: String = "simd_float4x4"
    static let size: Int = 64
    static let alignment: AlignType = .sixteen
}
