# TODO: specs
class NvidiaGPUStats
  def self.fetch
    collection = parse_command
    gpus = collection.dig("nvidia_smi_log", "gpu")
    gpus.map.with_index do |gpu, i|
      metric = new(gpu)
      metric.index = i
      metric
    end
  end

  def self.parse_command
    parser = Nori.new(parser: :rexml)
    parser.parse(command)
  end

  def self.command
    `nvidia-smi -q -x`
  end

  attr_accessor :index

  def initialize(params)
    @params = params
  end

  def name
    @params.dig("product_name")
  end

  def temperature
    @params.dig("temperature", "gpu_temp").to_i
  end

  def fan_speed
    @params.dig("fan_speed").to_i
  end

  def memory
    memory_usage = @params.dig("fb_memory_usage")
    {
      total: memory_usage&.dig("total").to_i,
      used: memory_usage&.dig("used").to_i,
      free: memory_usage&.dig("free").to_i
    }
  end

  def clocks
    clocks = @params.dig("clocks")

    {
      graphics: clocks&.dig("graphics_clock").to_i,
      sm: clocks&.dig("sm_clock").to_i,
      memory: clocks&.dig("mem_clock").to_i,
      video: clocks&.dig("video_clock").to_i
    }
  end

  def power
    power_readings = @params.dig("power_readings")

    {
      draw: power_readings&.dig("power_draw").to_i,
      limit: power_readings&.dig("power_limit").to_i
    }
  end

  def utilization
    utilization = @params.dig("utilization")

    {
      gpu: utilization&.dig("gpu_util").to_i,
      memory: utilization&.dig("memory_util").to_i
    }
  end
end
