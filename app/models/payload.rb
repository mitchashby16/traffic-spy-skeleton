class Payload < ActiveRecord::Base
  belongs_to :url
  belongs_to :user_agent
  belongs_to :registration
end
