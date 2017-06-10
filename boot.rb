require "bundler"
Bundler.setup

require "rack"
require "nori"
require_relative "exporter"
require_relative "nvidia_gpu_collector"
require_relative "nvidia_gpu_metrics"
