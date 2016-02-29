#
# Eg. Volunteer, Earn-a-bike, Paid
#
class WorkStatus < ActiveRecord::Base
  has_many :workers
  has_many :work_times

  validates_presence_of :name

  include XmlExtensions

  # Attributes accessible via the API
  API_ATTRIBUTES = [ :name, :created_at, :updated_at ]

end
