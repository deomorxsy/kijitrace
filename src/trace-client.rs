//use tonic::transport::Channel;
use tonic::{transport::Channel, Request, Status}
use opentelemetry::proto::metrics::v1::{MetricsServiceClient, ExportMetricsServiceRequest, ExportMetricsServiceResponse};

#[derive(Clone)]
pub struct OTLPCLient {
    //client: tonic::client::Grpc<tonic::transport::Channel>,
    client: MetricsServiceClient<Channel>,
}

impl OTLPClient {
    pub async fn new(addr: &str) -> Result<Self, Box<dyn std::error::Error>> {
        //let client = tonic::client::Grpc::new(Channel::from_shared(addr.to_string())?).await?;
        let channel = Channel::from_shared(addr.to_string())?.connect().await?;
        let client = MetricsServiceClient::new(channel);
        Ok(Self { client })
    }

    pub async fn export_metrics(
        &mut self, request: ExportMetricsServiceRequest,
        ) -> Result<ExportMetricsServiceResponse, Status> {
        self.client.export(Request::new(request)).await?.into_inner()
        //self.client.export(Request::new(request)).await.map(|res| res.into_inner())
    }
}
