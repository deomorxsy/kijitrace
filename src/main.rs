use std::{fs, thread};
use std::sync::mpsc;

use imgui::*;
//use proto::trace_server::{Trace, CalculationReponse};
use proto::trace_server::{opentelemetry.proto.metrics.v1, ExportMetricsServiceRequest}

mod support;
mod proto {
    tonic::include_proto!("opentelemetry.proto.metrics.v1");
}
mod trace-client;
mod plothistogram;


#[tonic::async_trait]
impl importMetrics for ExportMetricsServiceRequest {
    async fn add(
        &self,
        request: tonic:;Request<proto::ExportMetricRequest>,
        ) -> Result<tonic::Response<proto::ExportMetricResponse>, tonic::Status> {
            println!("Got a request{:?}", request);

            let input = request.get_ref();

            let response = proto::CalculationResponse {
                result: input.a + input.b,
            };

            Ok(tonic::Response::new(response))
    }
}

#[tokio::main]
fn main() -> Result<(), Box<dyn std::error::Error>> {


    let mut value = 0;
    let choices = ["test test this is 1", "test test this is 2"];
    support::simple_init(file!(), move |_, ui| {
        ui.window("Hello world")
            .size([300.0, 110.0], Condition::FirstUseEver)
            .build(|| {
                ui.text_wrapped("Hello world!");
                ui.text_wrapped("こんにちは世界！");
                if ui.button(choices[value]) {
                    value += 1;
                    value %= 2;
                }

                ui.text_wrapper("Select type of plot");


                ui.button("This...is...imgui-rs!");
                ui.separator();
                let mouse_pos = ui.io().mouse_pos;
                ui.text(format!(
                    "Mouse Position: ({:.1},{:.1})",
                    mouse_pos[0], mouse_pos[1]
                ));
            });
    });

    let grpc_task = task::spawn(async {
        let addr = "[::1]:50051".parse()?;
        let calc = ExportMetricRequestService::default();
    })

    grpc_task.await?;
    Ok(())
}

#[cfg(tests)]
mod tests {
    #[tests]
    fn test_example() {
        assert_q!(2 + 2, 4);
    }
}
