#
# Methods to make reports easier.
#
module Worker::WorkerReports
  extend ActiveSupport::Concern

  included do
  end

  # Class methods added to the object when {Worker::WorkerReports}
  # is included
  module ClassMethods
    # Have > 10 hours since last month
    #
    # @return [Array<Worker>] all workers with > 10 hours since last month
    def active_workers
      active_workers = []
      all.each do |w|
        if w.sum_time_in_seconds(DateTime.now - 30.days, DateTime.now) > 36000
          active_workers << w 
        end
      end
      return active_workers
    end

    # Have > 10 hours since last month and haven't been in the last two weeks
    #
    # @return [Array<Worker>] all workers with > 10 hours since last month
    #   and haven't been in the last two weeks
    def missing_list
      list = []
      active_workers.each do |w|
        if w.sum_time_in_seconds(DateTime.now - 14.days, DateTime.now) == 0
          list << w
        end
      end
      return list
    end

    # Find workers with identical names
    # this may be a problem with assigning work hours from xml backup
    #
    # @return [Array<String>] array of identical names
    def duplicate_names
      array = all.pluck(:name)
      array.select{|element| array.count(element) > 1 }.uniq
    end

  end

  # @return [Integer] the id of the {Worker} in the database before this one
  def previous
    w = Worker.where(['id < ?', self.id]).order('id DESC').limit(1).first
    return w.id if w
  end

  # @return [Integer] the id of the {Worker} in the database after this one
  def next
    w = Worker.where(['id > ?', self.id]).limit(1).first
    return w.id if w
  end

end
