class RouteObject

  def initialize
    @rules = []
  end

  def match(url, *args)
    options = {}
    options = args.pop if args[-1].is_a? Hash
    options[:default] ||= {}

    dest = args.size > 0 ? args.pop : nil
    raise 'Too many args' if args.size > 0

    parts = extract_url_parts(url)

    vars = []
    regexp_parts = combine_regexp(parts, vars)

    regexp = regexp_parts.join('/')
    @rules.push({
                    regexp: Regexp.new("^/#{regexp}$"),
                    vars: vars,
                    dest: dest,
                    options: options
                })
    STDERR.puts @rules
  end

  def check_url(url)
    @rules.each do |r|
      m = r[:regexp].match(url)

      if m
        options = r[:options]
        params = options[:default].dup
        r[:vars].each_with_index do |v,i|
          params[v] = m.captures[i]
        end

        dest = nil
        if r[:dest]
          return get_dest(r[:dest], params)
        else
          controller = params['controller']
          action = params['action'] || params[:action]
          return get_dest("#{controller}##{action}", params)
        end
      end
    end
    nil
  end

  def get_dest(dest, routing_params = {})
    return dest if dest.respond_to?(:call)
    if dest =~ /^([^#]+)#([^#]+)$/
      name = $1.capitalize
      controller = Object.const_get("#{name}Controller")
      return controller.action($2, routing_params)
    end
    raise "No destination: #{dest.inspect}"
  end

  private

  def extract_url_parts(url)
    parts = url.split('/')
    parts.select! { |p| !p.empty? }
    parts
  end

  def combine_regexp(parts, vars)
    parts.map do |part|
      if part[0] == ':'
        vars << part[1..-1]
        '([a-zA-Z0-9]+)'
      elsif part[0] == '*'
        vars << part[1..-1]
        '(.*)'
      else
        part
      end
    end
  end

end

module Shoebill

  class Application

    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval &block
    end

    def get_rack_app(env)
      raise 'No routes!' unless @route_obj
      @route_obj.check_url env['PATH_INFO']
    end

  end

end