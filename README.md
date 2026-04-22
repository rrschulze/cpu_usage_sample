# CPU Usage Sample

This sample is a demonstration of how to rapidly stand up a REST API to expose functionality from within the z/OS mainframe normally only available via green screen. Using in this case SDSF functionality that is made available through ISFJCALL we can access SDSF functions such as current CPU usage.

This sample is not intended to be used in a production environment as-is but instead is intended to serve as a template for exposing SDSF-backed functionality through a REST API on z/OS.

## Prerequisites

The project is intended to be built and run on z/OS only, where SDSF and `isfjcall.jar` are already present.

For more information about SDSF and ensuring your installation is running the Java SDK please consult publication: SC27-9028-30: z/OS SDSF User's Guide

## Build

Build the project on z/OS with IBM Semeru Runtime Certified Edition 17:
```
mvn clean verify
```

This project has been modernized to target Java 17 and Spring Boot 2.7.x on z/OS.

## Run

Start the application on z/OS using the local runtime environment where SDSF support is available.

Use the REST endpoints directly to confirm the sample is installed locally. The previous embedded Swagger UI based on springfox was removed during modernization because that library is not a reliable fit for the newer Spring/Java 17 stack.

Example endpoint:
```
/cpu/snapshot
```

Example `curl` request from z/OS USS:
```sh
curl -s http://localhost:8080/cpu/snapshot
```

Example `curl` request for the breakdown endpoint:
```sh
curl -s http://localhost:8080/cpu/breakdown
```

## OpenTelemetry Java agent

You can run the application with the OpenTelemetry Java agent to get spans printed to the console without changing the application code.

1. Download the OpenTelemetry Java agent jar on z/OS and place it somewhere accessible, for example:
```sh
/u/youruser/opentelemetry-javaagent.jar
```

2. Start the application with the agent enabled and configure console trace export:
```sh
java \
  -javaagent:/u/youruser/opentelemetry-javaagent.jar \
  -Dotel.service.name=cpu-usage-sample \
  -Dotel.traces.exporter=logging \
  -Dotel.metrics.exporter=none \
  -Dotel.logs.exporter=none \
  -jar target/cpu-1.0.0.jar
```

3. In another shell, invoke the application:
```sh
curl -s http://localhost:8080/cpu/snapshot
curl -s http://localhost:8080/cpu/breakdown
```

4. Observe spans written to the application console output by the agent.

Notes:
- This is no-code instrumentation; no source changes are required.
- The `logging` exporter prints span data locally to stdout/stderr for simple testing.
- If your z/OS environment requires additional JVM settings, keep the `-javaagent` and `-Dotel.*` options on the Java command line.

## Java 17 / z/OS notes

- Build and run with IBM Semeru Runtime Certified Edition 17 on z/OS.
- `isfjcall.jar` is expected to be present on the z/OS system.
- The application is designed for z/OS execution, where the SDSF Java integration is available.

## What Next?

1. Use this project as a template to enable your own API's
2. Extend this sample with additional API's from SDSF
