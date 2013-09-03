require "mongoid"
class Swap
  include Mongoid::Document
  include Mongoid::Timestamps
  field :skill_needed, :type => String
  field :skill_offered, :type => String
  field :user, :type => String
  field :filled, :type => Boolean, :default => false

  validates_presence_of :skill_needed
  validates_presence_of :skill_offered
  validates_presence_of :user
end
