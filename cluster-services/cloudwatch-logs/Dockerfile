# from fluent/fluentd-kubernetes-daemonset:v0.12-alpine-cloudwatch

# RUN gem update aws-sdk-core aws-sdk-cloudwatchlogs fluent-plugin-cloudwatch-logs

# -----------------------------------------------

FROM fluent/fluentd:v0.12.33-debian

MAINTAINER Eduardo Silva <eduardo@treasure-data.com>
USER root
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev libffi-dev" \
     && apt-get update \
     && apt-get upgrade -y \
     && apt-get install \
     -y --no-install-recommends \
     $buildDeps \
    && echo 'gem: --no-document' >> /etc/gemrc \
    && gem install fluent-plugin-secure-forward \
    && gem install fluent-plugin-record-reformer \
    && gem install fluent-plugin-detect-exceptions -v 0.0.9 \
    && gem install aws-sdk-core -v 3.19.0 \
    && gem install fluent-plugin-cloudwatch-logs -v 0.4.5 \
    && gem install fluent-plugin-kubernetes_metadata_filter \
    && gem install ffi \
    && gem install fluent-plugin-systemd -v 0.0.8 \
    && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
    && gem sources --clear-all \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# Copy configuration files
COPY ./conf/fluent.conf /fluentd/etc/
COPY ./conf/systemd.conf /fluentd/etc/
COPY ./conf/kubernetes.conf /fluentd/etc/

# Copy plugins
COPY plugins /fluentd/plugins/
COPY entrypoint.sh /fluentd/entrypoint.sh

# Environment variables
ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

# jemalloc is memory optimization only available for td-agent
# td-agent is provided and QA'ed by treasuredata as rpm/deb/.. package
# -> td-agent (stable) vs fluentd (edge)
#ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"

# Run Fluentd
CMD ["/fluentd/entrypoint.sh"]
