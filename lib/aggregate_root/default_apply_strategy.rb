module AggregateRoot
  module DefaultApplyStrategy
    def inject_apply_strategy!(event)
      send("apply_#{event.class.name.underscore.gsub('/', '_')}", event)
    end
  end
end
