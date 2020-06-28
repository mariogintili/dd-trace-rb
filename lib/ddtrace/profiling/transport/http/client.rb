require 'ddtrace/transport/http/client'
require 'ddtrace/profiling/transport/client'

module Datadog
  module Profiling
    module Transport
      module HTTP
        # Routes, encodes, and sends tracer data to the trace agent via HTTP.
        class Client < Datadog::Transport::HTTP::Client
          include Transport::Client

          # TODO: Consolidate API implementation with Datadog::Transport
          #       Just use :default_api for now.
          def initialize(apis, default_api)
            super(apis[default_api])
          end

          def send_profiling_flush(flush)
            # Build a request
            request = Profiling::Transport::Request.new(flush)
            send_payload(request)
          end

          def send_payload(request)
            send_request(request) do |api, env|
              api.send_profiling_flush(env)
            end
          end
        end
      end
    end
  end
end