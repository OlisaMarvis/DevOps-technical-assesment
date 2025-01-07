# DevOps-technical-assesment

# DevOps Engineer - Technical Assessment

## Section 1: Technical Questions

### 1. **Key Security Concerns in DevOps**
- **Secrets and Environment Variable Management**: Secure handling of environment variables, API keys, and certificates using tools like **Hashicorp Vault**, **AWS Secrets Manager**, or **Azure Key Vault**.
- **CI/CD Pipeline Security**: Ensure secure build processes with automated security testing in CI/CD pipelines.
- **Access Control**: Implement least privilege access and role-based access control (RBAC) across tools, services, and infrastructure.
- **Container Security**:
  - Regular scanning for vulnerabilities with tools like **Amazon Inspector**.
  - Use minimal base images.
  - Implement runtime security.
- **Infrastructure and Application Security**: Follow best practices for infrastructure and server setups.

---

### 2. **Designing a Self-Healing Distributed Service**
- **Health Checks**: Implement comprehensive health checks (e.g., liveness and readiness probes in Kubernetes).
- **Auto Scaling**: Use horizontal autoscaling tied to application or infrastructure metrics with tools like **HPA**, **Karpenter**, or **AWS Auto Scaling Groups**.
- **Monitoring and Alerts**:
  - Set up proactive monitoring with automated responses.
  - Centralized logging and tracing using tools like **ELK Stack** or **Grafana Loki**.
- **Deployment Strategies**: Use patterns like **blue-green deployments** or **rolling updates** for safe and reliable rollouts.
- **Redundancy**: Deploy across multiple availability zones and regions for high availability.

---

### 3. **Centralized Logging Solution for Microservices**
#### **Implementation Overview**
1. **Log Collection**: Deploy **Fluentd** as a DaemonSet in Kubernetes or use Helm charts for deployment.
2. **Processing**: Use **Logstash** for log parsing and enrichment.
3. **Storage**: Store logs in **Elasticsearch** for scalable storage and fast retrieval.
4. **Visualization**: Analyze logs with **Kibana** and monitor metrics with **Grafana**.
5. **Retention**: Implement log rotation and archival policies with **AWS S3** for cost efficiency.
6. **Access Control**: Enforce role-based access to logs for security.

[Design Reference](https://github.com/OlisaMarvis/DevOps-technical-assesment/blob/main/Centralised-logging.md)

---

### 4. **Reasons for Choosing Terraform**
- **Infrastructure as Code (IaC)**: Declarative approach to manage infrastructure.
- **Provider Ecosystem**: Supports a wide range of cloud and service providers.
- **State Management**: Robust state tracking and locking mechanisms.
- **Plan & Apply**: Preview infrastructure changes before applying them.
- **Modularity**: Reusable modules for common infrastructure patterns.
- **Version Control**: Track and manage infrastructure changes with versioning.
- **Community Support**: Large community and extensive documentation.
- **Multi-Cloud**: Consistent workflow across multiple cloud providers.

---

### 5. **Designing a Secure CI/CD Architecture for Microservices with GitOps**
#### **Scenario Overview**
- **Microservices Count**: 20 microservices, written in different languages.
- **Environment**: Orchestrated with Kubernetes.

#### **Implementation Details**
1. **Source Control**: Separate repositories for application code and infrastructure configurations.
2. **Security**:
   - Automated security scanning at multiple stages.
   - External secrets management with tools like **Hashicorp Vault** or **AWS Secrets Manager**.
3. **CI Pipeline**:
   - Language-specific build agents for efficient builds.
   - Secure minimal base images with vulnerability scanning.
4. **GitOps**: Use **ArgoCD** for declarative Kubernetes deployments.
5. **Monitoring**: Integrated observability stack with tools like **Prometheus**, **Grafana**, and **Slack notifications** for build failures.

---

## Section 2: Coding Challenge

### 7. **Write a Prometheus exporter in Python/Golang that connects to the specified RabbitMQ HTTP API.**
The exporter should periodically read the following information about all queues in all vhosts.

**Solution**: [Prometheus Exporter](https://github.com/OlisaMarvis/DevOps-technical-assesment/blob/main/prom-exporter.py)

---

### 8. **Write a script to restart the Laravel backend service if CPU usage exceeds 80%.**

**Solution**: [Laravel Restart Script](https://github.com/OlisaMarvis/DevOps-technical-assesment/blob/main/laravel-script.sh)

---

### 9. **A Postgres query is running slower than expected. Explain your approach to troubleshooting it.**

#### **Approach**
1. **Review Locking and Contention**:
   - Use `pg_stat_activity` to identify locking or contention:
     ```sql
     SELECT * FROM pg_stat_activity WHERE state = 'active';
     ```

2. **Analyze Query Execution**:
   - Use `EXPLAIN` or `EXPLAIN ANALYZE` to understand query execution plans:
     ```sql
     EXPLAIN ANALYZE <your_query>;
     ```

3. **Check Indexes**:
   - Ensure important fields are properly indexed:
     ```sql
     CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
     ```

4. **Optimize Database Configuration**:
   - **Memory Settings**: Ensure sufficient memory is allocated for query execution (e.g., `work_mem`).
   - **Autovacuum**: Tune autovacuum settings to avoid bloated tables.
   - **Connection Settings**: Verify configurations like `max_connections` and `shared_buffers`.

5. **Denormalization (if needed)**:
   - Simplify data structures for faster query access where appropriate.

6. **Test and Verify**:
   - Re-run the query to check for improvements.
   - Escalate to developers or database administrators if necessary and provide recommendations.

---

### 10. **Write a Dockerfile to containerize a Laravel application.**

**Solution**: [Dockerfile for Laravel](https://github.com/OlisaMarvis/DevOps-technical-assesment/blob/main/Dockerfile)

---

## Section 3: Monitoring and Troubleshooting

### 11. **How would you set up monitoring for the React Native mobile app’s API endpoints?**

#### **Implementation**
1. **End-to-End Monitoring**:
   - Use **Application Performance Monitoring (APM)** tools like **Datadog**, **New Relic**, or **Dynatrace** to monitor:
     - API performance
     - User interactions
     - Network request timings

2. **Distributed Tracing**:
   - Integrate tools like **Jaeger** or **OpenTelemetry** to trace API requests from the app to the backend and database services.

3. **Alerting**:
   - Use **AWS CloudWatch**, **Slack**, or **PagerDuty** to set up alerts based on predefined thresholds.

4. **Visualization**:
   - Build dashboards using tools like **Grafana**, Kubernetes Dashboard, or Lens.

5. **Centralized Logging**:
   - Aggregate logs from the React Native app and backend APIs using tools like:
     - **ELK Stack** (Elasticsearch, Logstash, Kibana)
     - **Fluentd** + **Grafana Loki**

---

### 12. **Explain how you would debug high latency in Node.js microservices.**

#### **Approach**
1. **Establish Observability**:
   - **Distributed Tracing**:
     - Use tools like **Jaeger** or **OpenTelemetry** to trace requests across the microservices architecture.
     - Identify latency points (e.g., services, databases, or external APIs).
   - **Key Metrics Monitoring**:
     - Use **Prometheus + Grafana** or **Datadog** to track:
       - Response time (P50, P90, P99 latency)
       - Error rates
       - CPU, memory, and I/O usage for each Node.js service

2. **Analyze Infrastructure and Network**:
   - Inspect network latency and bandwidth using tools like `ping` or `traceroute`.
   - Use Kubernetes metrics to verify resource utilization:
     ```bash
     kubectl top nodes
     kubectl top pods
     ```
   - Check container resource limits and throttling.

3. **Automation and Documentation**:
   - Add continuous profiling and automated anomaly detection in production environments.
   - Maintain detailed runbooks for quick resolution of similar issues.

---

## Section 4: Behavioral

### 13. **Describe a time you improved the performance of an infrastructure system. What challenges did you face?**

#### **Scenario**
In a previous role, I addressed performance issues in a Kubernetes production cluster that experienced high latency and frequent pod evictions.

#### **Challenges**
- **Node Resource Fragmentation**: Inefficient pod scheduling.
- **Network Policies**: Poor configurations increased latency.
- **Pod Resource Requests/Limits**: Suboptimal configurations caused instability.
- **Monitoring**: Lack of proper metrics for cluster health.

#### **Solutions**
1. **Cluster Optimization**:
   - Implemented **cluster-autoscaler** with custom scaling policies.
   - Configured **Pod Disruption Budgets** to maintain service availability.
2. **Resource Management**:
   - Used **Horizontal Pod Autoscaling (HPA)** to dynamically adjust pod resources.
   - Configured custom scheduling policies with pod affinity/anti-affinity.
   - Implemented proper QoS classes for critical workloads.
3. **Monitoring Enhancements**:
   - Deployed **Prometheus** with custom alerts for cluster health.
   - Built **Grafana dashboards** for real-time visibility.
   - Integrated **kube-state-metrics** for detailed insights.

#### **Results**
- Reduced pod scheduling latency by **60%**.
- Achieved **99.99% uptime**.
- Decreased resource costs by **30%** through improved utilization.

---

### 14. **How do you prioritize tasks when multiple urgent issues arise?**

#### **Approach**
1. **Assess Impact**:
   - Determine the number of affected users.
   - Identify business-critical services that are down.
   - Evaluate revenue impact.

2. **Take Action**:
   - Focus on resolving the most critical issue first.
   - Track and communicate the status of other issues.
   - Leverage runbooks for faster resolutions.
   - Delegate less critical tasks to teammates when appropriate.

3. **Communication**:
   - Keep stakeholders informed about progress.
   - Clearly state which issues are being addressed and which require assistance.
   - Document steps for future reference.

4. **Follow-Up**:
   - Review resolved incidents and update documentation.
   - Share learnings with the team.
   - Implement preventive measures to avoid similar problems.

#### **Example**
While monitoring systems, I encountered multiple alerts:
- The main application was running slow (critical customer impact).
- An overnight backup failed.
- The development team couldn’t access the test environment.

**Resolution**:
- Focused on resolving the slow application issue first as it affected customers.
- Communicated the backup failure and test environment issue to appropriate teams for planning resolution.
- Documented all actions and updated stakeholders on progress.

---

