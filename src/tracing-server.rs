use tonic::{Requests, Status};

#[derive(serde::Serialize, serde::Deserialize, Clone, Debug)]
pub struct Resource {
    // resource attributes
}

#[derive(serde::Serialize, serde::Deserialize, Clone, Debug)]
pub struct InstrumentationLibrary {
    // instrumentation library information
}

#[derive(serde::Serialize, serde::Deserialize, Clone, Debug)]
pub struct Metric {
    // metric data
}

#[derive(serde::Serialize, serde::Deserialize, Clone, Debug)]
pub struct ExportMetricsServiceRequest {
    resource: Resource,
    instrumentation_library: InstrumentationLibrary,
    data_points: Vec<Metric>,
}

