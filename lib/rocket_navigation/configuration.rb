module RocketNavigation
  def self.configuration
    @configuration ||= Configuration.new
  end
  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :renderer

    def initialize
      @renderer = RocketNavigation::Renderer::List
    end
  end
end

