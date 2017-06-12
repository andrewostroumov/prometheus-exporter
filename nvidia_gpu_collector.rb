class NvidiaGPUCollector
  def initialize(registry:)
    @registry = registry
  end

  def init_metrics
    @temperature        = @registry.gauge(:gpu_temperature, "GPU core temperature")
    @fan_speed          = @registry.gauge(:gpu_fan_speed, "GPU fan speed")

    @utilization_gpu    = @registry.gauge(:gpu_utilization_gpu, "GPU utilization GPU")
    @utilization_memory = @registry.gauge(:gpu_utilization_memory, "GPU utilization memory")

    @clocks_graphics    = @registry.gauge(:gpu_clocks_graphics, "GPU clocks graphics")
    @clocks_sm          = @registry.gauge(:gpu_clocks_sm, "GPU clocks sm")
    @clocks_memory      = @registry.gauge(:gpu_clocks_memory, "GPU clocks memory")
    @clocks_video       = @registry.gauge(:gpu_clocks_video, "GPU clocks video")

    @power_draw         = @registry.gauge(:gpu_power_draw, "GPU power draw")
    @power_limit        = @registry.gauge(:gpu_power_limit, "GPU power limit")

    @memory_total       = @registry.gauge(:gpu_memory_total, "GPU memory total")
    @memory_used        = @registry.gauge(:gpu_memory_used, "GPU memory used")
    @memory_free        = @registry.gauge(:gpu_memory_free, "GPU memory free")
  end

  def update
    metrics.each do |metric|
      @temperature.set({ index: metric.index, name: metric.name }, metric.temperature)
      @fan_speed.set({ index: metric.index, name: metric.name }, metric.fan_speed)

      @utilization_gpu.set({ index: metric.index, name: metric.name }, metric.utilization[:gpu])
      @utilization_memory.set({ index: metric.index, name: metric.name }, metric.utilization[:memory])

      @clocks_graphics.set({ index: metric.index, name: metric.name }, metric.clocks[:graphics])
      @clocks_sm.set({ index: metric.index, name: metric.name }, metric.clocks[:sm])
      @clocks_memory.set({ index: metric.index, name: metric.name }, metric.clocks[:memory])
      @clocks_video.set({ index: metric.index, name: metric.name }, metric.clocks[:video])

      @power_draw.set({ index: metric.index, name: metric.name }, metric.power[:draw])
      @power_limit.set({ index: metric.index, name: metric.name }, metric.power[:limit])

      @memory_total.set({ index: metric.index, name: metric.name }, metric.memory[:total])
      @memory_used.set({ index: metric.index, name: metric.name }, metric.memory[:used])
      @memory_free.set({ index: metric.index, name: metric.name }, metric.memory[:free])
    end
  end

  private

  def metrics
    NvidiaGPUStats.fetch
  end
end
