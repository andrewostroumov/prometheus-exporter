class NvidiaGPUCollector
  def initialize(registry:)
    @registry = registry
  end

  def init_metrics
    @temperature = @registry.gauge(:gpu_temperature, "GPU core temperature")
    @fan_speed = @registry.gauge(:gpu_fan_speed, "GPU fan speed")
  end

  def update
    metrics.each do |metric|
      @temperature.set({ index: metric.index }, metric.temperature)
      @fan_speed.set({ index: metric.index }, metric.fan_speed)
    end
  end

  private

  def metrics
    NvidiaGPUMetrics.fetch
  end
end
