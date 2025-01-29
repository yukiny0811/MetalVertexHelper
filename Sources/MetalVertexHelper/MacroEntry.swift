
@attached(
    member,
    names: named(cObject), named(generateVertexDescriptor), named(memorySize)
)
public macro VertexObject() = #externalMacro(module: "MetalVertexHelperMacros", type: "VertexObject")
