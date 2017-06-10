require "prometheus/middleware/exporter"

class Exporter < Prometheus::Middleware::Exporter
  def initialize(app, options = {})
    super
    init_collectors
    init_metrics
  end

  def call(env)
    if env["PATH_INFO"] == @path
      @collectors.each(&:update)
    end
    super
  end

  private

  def init_collectors
    @collectors = []
    @collectors << NvidiaGPUCollector.new(registry: @registry)
  end

  def init_metrics
    @collectors.each(&:init_metrics)
  end
end
