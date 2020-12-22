# Dockerfile for testing plugin installation

FROM logstash:7.6.0

RUN logstash-plugin install ./logstash-filter-csharp.gem
