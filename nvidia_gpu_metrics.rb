class NvidiaGPUMetrics
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

  def temperature
    @params.dig("temperature", "gpu_temp").to_i
  end
end
