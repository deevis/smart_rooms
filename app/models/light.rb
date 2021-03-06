# == Schema Information
#
# Table name: lights
#
#  id         :bigint           not null, primary key
#  entity_id  :string(255)
#  name       :string(255)
#  room_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Light < ApplicationRecord

    belongs_to :room

    validates_presence_of :entity_id
    validates_uniqueness_of :entity_id
    validates_presence_of :name
    validates_uniqueness_of :name

    def set_color(r, g, b)
      NodeRedService.post(:rgb_light, entity_id: self.entity_id, r: r, g: g, b: b)
    end

    def self.set_all_color(r,g,b)
      threads = []
      Light.order(:entity_id).all.each do |l|
        threads << Thread.new { l.set_color(r,g,b)}
      end
      threads.map{|t| t.value}
    end

    def self.color_cycle_all(count=1000, colors =  [[255,0,0], [0,255,0], [0,0,255], [255,0,255]])
      Thread.new {count.times{ colors.each{|r,g,b| Light.set_all_color(r,g,b); sleep 4}}}
      "Cycling started on background thread"
    end
end
