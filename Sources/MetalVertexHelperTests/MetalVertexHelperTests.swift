//
//  File.swift
//  MetalVertexHelper
//
//  Created by Yuki Kuwashima on 2025/10/06.
//

import Testing
import simd
import Metal
@testable import MetalVertexHelper

@VertexObject
struct MyVertex {
    var position: simd_float3
    var color: simd_float4
    var texCoord: simd_float2
}

struct MetalVertexHelperTests {

    private static let expectedOffsets: [Int] = [0, 16, 32]
    private static let expectedFormats: [MTLVertexFormat] = [.float3, .float4, .float2]
    private static let expectedBufferIndex = 0
    private static let expectedStride = 48

    @Test
    func descriptor_formats_offsets_and_bufferIndices_are_correct() throws {
        let desc = MyVertex.generateVertexDescriptor()

        // attributes[0] -> position: float3 at offset 0
        #expect(desc.attributes[0].format == Self.expectedFormats[0])
        #expect(desc.attributes[0].offset == Self.expectedOffsets[0])
        #expect(desc.attributes[0].bufferIndex == Self.expectedBufferIndex)

        // attributes[1] -> color: float4 at offset 16
        #expect(desc.attributes[1].format == Self.expectedFormats[1])
        #expect(desc.attributes[1].offset == Self.expectedOffsets[1])
        #expect(desc.attributes[1].bufferIndex == Self.expectedBufferIndex)

        // attributes[2] -> texCoord: float2 at offset 32
        #expect(desc.attributes[2].format == Self.expectedFormats[2])
        #expect(desc.attributes[2].offset == Self.expectedOffsets[2])
        #expect(desc.attributes[2].bufferIndex == Self.expectedBufferIndex)
    }

    @Test
    func descriptor_layout_stride_and_step_are_correct() throws {
        let desc = MyVertex.generateVertexDescriptor()
        guard let layout = desc.layouts[0] else {
            throw NSError()
        }

        #expect(layout.stride == Self.expectedStride)
        #expect(layout.stepRate == 1)
        #expect(layout.stepFunction == .perVertex)
    }

    @Test
    func memorySize_matches_descriptor_stride() throws {
        let desc = MyVertex.generateVertexDescriptor()
        #expect(MyVertex.memorySize == Self.expectedStride)
        #expect(desc.layouts[0].stride == MyVertex.memorySize)
    }

    @Test
    func memorySize_matches_Swift_stride() throws {
        #expect(MyVertex.memorySize == MemoryLayout<MyVertex>.stride)
    }
}
