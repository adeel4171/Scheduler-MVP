class Schedule < ApplicationRecord
	belongs_to :user
	serialize :days, JSON
	validates :user_id, presence: true
end
