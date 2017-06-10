class NvidiaGPUCollector
  def initialize(registry:)
    @registry = registry
  end

  def init_metrics
    @temperature = @registry.gauge(:gpu_temperature, "GPU core temperature")
  end

  def update
    metrics.each do |metric|
      @temperature.set({ index: metric.index }, metric.temperature)
    end
  end

  private

  def metrics
    NvidiaGPUMetrics.fetch
  end
end
