module EventsHelper
  def format_created_at(created_at)
    DateTime.parse(created_at).strftime('%Y-%m-%d %H:%M:%S') if created_at
  end
end