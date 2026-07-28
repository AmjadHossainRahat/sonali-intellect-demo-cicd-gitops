package com.sonaliintellect.training.api;

import java.time.OffsetDateTime;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class InfoController {
    private final String version;
    private final String commitSha;
    private final String buildTime;
    private final String podName;

    public InfoController(
            @Value("${app.version:0.1.0}") String version,
            @Value("${BUILD_COMMIT:local}") String commitSha,
            @Value("${BUILD_TIME:local}") String buildTime,
            @Value("${HOSTNAME:local}") String podName) {
        this.version = version;
        this.commitSha = commitSha;
        this.buildTime = buildTime;
        this.podName = podName;
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        return Map.of(
                "application", "sonali-intellect-demo-cicd-gitops",
                "message", "Sonali Intellect CI/CD and GitOps demo application is running.",
                "version", version,
                "podName", podName,
                "timestamp", OffsetDateTime.now().toString());
    }

    @GetMapping("/api/version")
    public Map<String, String> version() {
        return Map.of(
                "application", "sonali-intellect-demo-cicd-gitops",
                "version", version,
                "commitSha", commitSha);
    }

    @GetMapping("/api/build-info")
    public Map<String, String> buildInfo() {
        return Map.of(
                "application", "sonali-intellect-demo-cicd-gitops",
                "version", version,
                "commitSha", commitSha,
                "buildTime", buildTime,
                "podName", podName);
    }
}

