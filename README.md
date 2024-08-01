## Kijitrace
>  an imGUI for kernel instrumentation and trace monitoring

[![imgui](https://github.com/deomorxsy/kijitrace/actions/workflows/ci.yml/badge.svg)](https://github.com/deomorxsy/kijitrace/actions/workflows/ci.yml)
[![wasm](https://github.com/deomorxsy/kijitrace/actions/workflows/wasm.yml/badge.svg)](https://github.com/deomorxsy/kijitrace/actions/workflows/wasm.yml)
[![android](https://github.com/deomorxsy/kijitrace/actions/workflows/android.yml/badge.svg)](https://github.com/deomorxsy/kijitrace/actions/workflows/android.yml)

This projects aims to create immediate GUI for x86_64, wasm and android with visualization of kernel instrumentation and tracing, which it consumes as a OTLP/gRPC client.

Featuring:
- imgui-rs for the windowing
- winit, a window handling library (platform integration)
- glium, a high-level safe OpenGL wrapper which renders the geometry drawings from imgui-rs (rendering)
- glutin, a low-level OpenGL context creation library (platform integration)
- prost to deal with protobuf (protocol buffers), a mechanism to serialize structured data. Used in async environments alongside Tokio, it uses serde to deserialize Protobuf.
- tonic to deal with gRPC. Depends on prost so you don't need .proto files
- serde to serialize and deserialize rust data structures such as json.
- tokio to leverage the async runtime. prost is part of tokio.

Roadmap:
- [] organize both OTLP/gRPC and imGUI into two separated and synchronized threads
- [x] imGUI prototype
- [] wasm cross-compilation: wasm-packer
- [x] android cross-compilation
- [] Trace data format: OTLP (opentelemetry)
- [] Tracing sources: eBPF, perf, Ftrace
- [] Visualization: Heatmaps, Flamegraph, log2 histograms
