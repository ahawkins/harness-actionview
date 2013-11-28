require 'harness'

events = %w(render_template render_partial)

events.each do |name|
  ActiveSupport::Notifications.subscribe "#{name}.action_view" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    identifier = event.payload.fetch :identifier

    path = identifier.gsub /^.+app\/views\//, ''
    paths = path.gsub('/', '.').split('.')
    paths.pop

    template = paths.join '.'

    Harness.timing "action_view.#{name}.#{template}", event.duration
  end
end
