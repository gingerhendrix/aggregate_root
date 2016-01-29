class FakeEventStore
  NotSupported = Class.new(StandardError)

  def initialize
    @repository = {}
  end
  attr_reader :repository

  def publish_event(event_data, stream_name = GLOBAL_STREAM, expected_version = nil)
    raise RubyEventStore::WrongExpectedEventVersion if version_incorrect?(stream_name, expected_version)
    repository[stream_name] = [] unless repository.key?(stream_name)
    repository[stream_name] << event_data
    event_data
  end

  def delete_stream(stream_name)
    @repository = repository.except(stream_name)
    nil
  end

  def read_events(stream_name, start, count)
    read_all_events(stream_name)[start-1, count]
  end

  def read_all_events(stream_name)
    repository.fetch(stream_name, [])
  end

  def read_all_streams
    repository.flat_map{ |stream, events| events }
  end

  def subscribe(subscriber, event_types)
    raise NotSupported
  end

  def subscribe_to_all_events(subscriber)
    raise NotSupported
  end

  private

  def version_incorrect?(stream_name, expected_version)
    unless expected_version.nil?
      find_last_event_version(stream_name) != expected_version
    end
  end

  def find_last_event_version(stream_name)
    read_all_events(stream_name).last.event_id
  end
end
