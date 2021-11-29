# == Schema Information
#
# Table name: rooms
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  door_contact_id  :string(255)
#  speaker_id       :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  cooldown_seconds :integer          default(5)
#  cooldown_started :datetime
#  quiet_hours      :string(255)
#  say_services     :string(4000)
#
class Room < ApplicationRecord
  has_many :door_messages
  has_many :lights

  serialize :say_services, Array

  default_scope ->{order("name ASC")}

  validates_format_of :quiet_hours, with: /\d\d?[ap]m-\d\d?[ap]m/, allows_nil: true, allows_blank: true


  def say(message=nil)
    message = get_message if message.blank?
    message = message.gsub("\n", "  ").gsub("'", "").gsub("&", "and").gsub("\"", "").gsub("\r", "").gsub("\t", "")
    NodeRedService.get(:say, {speaker: speaker_id, message: message})
    message
  end

  def get_message
    # was originally: room.door_messages.sample.message
    options = say_services.clone
    options << :door_messages if door_messages.present?
    chosen = options.sample
    case(chosen)
    when :door_messages
      door_messages.sample.message
    else
       JokeGenerator.tell_joke(chosen)
    end
  end

  def cooling_down?
    currently_cooling_down = if cooldown_started
      Time.now < (self.cooldown_started + self.cooldown_seconds) 
    else
      false
    end
    if !currently_cooling_down
      # Start our next cooldown period
      self.cooldown_started = Time.now
      save!
    end
    currently_cooling_down
  end

  def quiet_hours?
    return false if self.quiet_hours.blank?
    # "9am-3pm", or "10pm-8am"
    start_time, end_time = self.quiet_hours.split("-")
    if start_time.index("pm") && end_time.index("am")
      # this is overnight, perform 2 checks...
      Time.now.between?(Time.parse(start_time), Time.parse("11:59:59.999pm")) ||
      Time.now.between?(Time.parse("12am"), Time.parse(end_time))
    else
      Time.now.between?(Time.parse(start_time), Time.parse(end_time))
    end
  end

end
