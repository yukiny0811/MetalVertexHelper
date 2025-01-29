# MetalVertexHelper

Before Macro Expansion
<img width="1256" alt="image" src="https://github.com/user-attachments/assets/cd64068e-bd2b-40c8-a8ab-451114b9fbc1" />

After Macro Expansion
<img width="1782" alt="image" src="https://github.com/user-attachments/assets/c45080a0-f393-47a1-85e0-77653d6cd6c8" />


MetalVertexHelper is a Swift package designed to simplify the creation and management of vertex data for Metal applications. Have you ever struggled with memory alignment between Swift and Metal? MetalVertexHelper was created to solve that very problem. By leveraging Swift's powerful macro system, MetalVertexHelper automatically generates essential components such as C-compatible objects, vertex descriptors, and memory size calculations based on your Swift structs. Simply annotate your Swift struct with @VertexObject, and MetalVertexHelper will handle the necessary padding to align with Metal's requirements, ensuring type safety, reducing boilerplate code, and enhancing performance in your Metal-based graphics and compute applications.


## Features

- **Automatic C-Compatible Object Generation:** Converts Swift vertex structs into C-compatible tuples, including necessary padding for alignment.
- **Vertex Descriptor Generation:** Automatically creates `MTLVertexDescriptor` instances based on your vertex data, ensuring optimal memory layout and performance.
- **Memory Size Calculation:** Computes the memory size required for your vertex structures, facilitating efficient buffer allocations.

## Installation

MetalVertexHelper is distributed via Swift Package Manager. To add it to your project:

1. **Add Dependency:**

   In your `Package.swift`, add MetalVertexHelper as a dependency:

   ```swift
   dependencies: [
       .package(url: "https://github.com/yourusername/MetalVertexHelper.git", exact: "1.0.0"),
   ],
   ```

2. **Add to Targets:**

   Include `MetalVertexHelper` in the dependencies of your target:

   ```swift
   targets: [
       .target(
           name: "YourTarget",
           dependencies: [
               "MetalVertexHelper",
           ]
       ),
       // ... other targets
   ]
   ```

3. **Run Package Update:**

   Execute the following command to fetch and integrate the package:

   ```bash
   swift package update
   ```

## Usage

MetalVertexHelper provides a macro called `@VertexObject` that you can apply to your vertex structs. This macro automatically generates additional properties and methods to facilitate Metal integration.

### Applying the `@VertexObject` Macro

1. **Import MetalVertexHelper:**

   ```swift
   import MetalVertexHelper
   ```

2. **Define Your Vertex Struct:**

   Annotate your struct with the `@VertexObject` macro. Define your vertex attributes using supported types.

   ```swift
   @VertexObject
   struct MyVertex {
       var position: simd_float3
       var color: simd_float4
       var texCoord: simd_float2
   }
   ```

### Generated Members

Applying the `@VertexObject` macro to your struct generates the following members:

- **`cObject` Property:**

  A C-compatible tuple representation of your vertex data, including any necessary padding for alignment.

  ```swift
  public var cObject: (simd_float3, simd_float4, simd_float2, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool, Bool) { (position, color, texCoord, false, false, false, false, false, false, false, false, false, false, false, false, false) }
  ```

- **`generateVertexDescriptor()` Method:**

  Generates a `MTLVertexDescriptor` based on your vertex attributes, configuring formats, offsets, and buffer indices.

  ```swift
  public static func generateVertexDescriptor() -> MTLVertexDescriptor {
      let descriptor = MTLVertexDescriptor()

      descriptor.attributes[0].format = .float3
      descriptor.attributes[0].offset = 0
      descriptor.attributes[0].bufferIndex = 0

      descriptor.attributes[1].format = .float4
      descriptor.attributes[1].offset = 16
      descriptor.attributes[1].bufferIndex = 0

      descriptor.attributes[2].format = .float2
      descriptor.attributes[2].offset = 32
      descriptor.attributes[2].bufferIndex = 0

      descriptor.layouts[0].stride = 48
      descriptor.layouts[0].stepRate = 1
      descriptor.layouts[0].stepFunction = .perVertex

      return descriptor
  }
  ```

- **`memorySize` Property:**

  Provides the memory size required for the vertex struct, facilitating buffer allocations.

  ```swift
  public static var memorySize: Int { 48 }
  ```

## Supported Types

MetalVertexHelper supports a variety of scalar and SIMD types to accommodate different vertex attribute requirements. Below is a comprehensive list of supported types:

### Scalar Types

- `Bool`
- `Int8`
- `UInt8`
- `Int16`
- `UInt16`
- `Int32`
- `UInt32`
- `Int` (Int64 on 64-bit platforms)
- `Float16`
- `Float`

### SIMD Types

- `simd_int2`
- `simd_uint2`
- `simd_int3`
- `simd_uint3`
- `simd_int4`
- `simd_uint4`
- `simd_float2`
- `simd_float3`
- `simd_float4`
- `simd_half2`
- `simd_half3`
- `simd_half4`

### Matrix Types

- `simd_half2x2`
- `simd_half2x3`
- `simd_half2x4`
- `simd_half3x2`
- `simd_half3x3`
- `simd_half3x4`
- `simd_half4x2`
- `simd_half4x3`
- `simd_half4x4`
- `simd_float2x2`
- `simd_float2x3`
- `simd_float2x4`
- `simd_float3x2`
- `simd_float3x3`
- `simd_float3x4`
- `simd_float4x2`
- `simd_float4x3`
- `simd_float4x4`

**Note:** Attempting to use unsupported types will result in a compile-time error.

## Example

Below is a step-by-step example demonstrating how to use MetalVertexHelper in a Metal project.

### Step 1: Define Your Vertex Struct

Annotate your vertex struct with `@VertexObject` and define your vertex attributes using supported types.

```swift
import MetalVertexHelper
import simd

@VertexObject
struct Vertex {
    var position: simd_float3
    var color: simd_float4
    var texCoord: simd_float2
}
```

### Step 2: Access Generated Members

MetalVertexHelper automatically generates additional members for your struct.

```swift
// Access the C-compatible object
let cVertex = Vertex(position: [0, 0, 0], color: [1, 0, 0, 1], texCoord: [0, 0]).cObject

// Generate the vertex descriptor
let vertexDescriptor = Vertex.generateVertexDescriptor()

// Get the memory size
let vertexSize = Vertex.memorySize
```

### Step 3: Configure Metal Pipeline

Use the generated `MTLVertexDescriptor` in your Metal pipeline setup.

```swift
import Metal

// Assuming you have a Metal device
let device: MTLDevice = MTLCreateSystemDefaultDevice()!

// Create a render pipeline descriptor
let pipelineDescriptor = MTLRenderPipelineDescriptor()
pipelineDescriptor.vertexDescriptor = Vertex.generateVertexDescriptor()

// Configure other pipeline settings
// ...

// Create the pipeline state
let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
```

### Step 4: Allocate Vertex Buffer

Use the `memorySize` to allocate a vertex buffer.

```swift
// Populate the buffer with vertex data
let vertices: [Vertex] = [
    Vertex(position: [0, 0, 0], color: [1, 0, 0, 1], texCoord: [0, 0]),
    // ... other vertices
]
let vertexBuffer = device.makeBuffer(bytes: vertices.map { $0.cObject }, length: Vertex.memorySize * vertexCount)!
```

## License


---

Happy Coding! 🚀
