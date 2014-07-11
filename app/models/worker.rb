class Worker < ActiveRecord::Base
  has_many :work_times, dependent: :destroy
  has_one :survey, dependent: :destroy
  belongs_to :status
  belongs_to :work_status

  validates_presence_of :name

  include XmlExtensions
  include Worker::WorkerAlternates
  include Worker::WorkerPhone

  mount_uploader :image, AvatarUploader

  STATUS = ["Volunteer", "Member", "Paid Staff"] 

  scope :email_only, -> { where("email IS NOT NULL AND phone IS NULL") }
  scope :has_email, -> { where("email IS NOT NULL") }
  scope :has_phone, -> { where("phone IS NOT NULL") }
  scope :no_contact, -> { where("email IS NULL AND phone IS NULL") }

  scope :clocked_in, -> { where(in_shop: true) }
  scope :clocked_out, -> { where(in_shop: false).order('updated_at DESC') }

  # Find workers with identical names
  # this may be a problem with assigning work hours from xml backup
  #
  def self.duplicate_names
    array = all.map(&:name)
    array.select{|element| array.count(element) > 1 }.uniq
  end

  # Carrierwave doesn't allow image field to be assigned directly
  # Must pass a file to be written on assignment.
  #
  def seed_image; image; end
  def seed_image=(val)
    path = File.join(Rails.root, 'public', val)
    self.image = open(path) if File.exists?(path)
  end

  def avatar_url
    image_url
    #if image.nil? then return Settings.avatars.missing_url
    #elsif image =~ /\w+\/\w+/ then
    #  return image_exists? ? "/system/#{image}" : Settings.avatars.missing_url
    #elsif image_exists? then return "/assets/default_avatars/#{image}"
    #else return Settings.avatars.missing_url
    #end
  end

  def avatar_path
    image.path
    #if image.nil?
    #  return File.join(Settings.avatars.missing_path.split('/'))
    #elsif image =~ /\w+\/\w+/
    #  File.join("public", "system", image.split("/"))
    #else
    #  # If the image name has no directory marks, assume its from the default
    #  File.join("app", "assets", "images", "default_avatars", image)
    #end
  end

  def image_exists?
    File.exists?(avatar_path)
  end

  def previous
    w = Worker.where(['id < ?', self.id]).order('id DESC').limit(1).first
    return w.id if w
  end

  def next
    w = Worker.where(['id > ?', self.id]).limit(1).first
    return w.id if w
  end

  def has_hours?
    work_times.empty? ? false : true
  end

  def is_in_shop?
    latest_record.is_open?
  end

  def latest_record
    @sorted_hours ||= work_times.sort_by { |h| h.start_at }
    @sorted_hours[-1]
  end

  def oldest_record
    @sorted_hours ||= work_times.sort_by { |h| h.start_at }
    @sorted_hours[0]
  end

  def sum_time_in_seconds(begin_time, end_time)
    time = WorkTime.worker_id_between(id, begin_time, end_time)
    return time.to_a.sum(&:difference_in_seconds)
  end

  def sum_time_in_hours(begin_time, end_time)
    return sum_time_in_seconds(begin_time, end_time) / (60 * 60)
  end

  def created_datetime
    created_at.strftime("%a %b %d %Y")
  end

  def last_visit_text
    if not has_hours? then I18n.t "messages.new_volunteer"
    elsif is_in_shop? then I18n.t "messages.in_shop"
    else I18n.t "messages.last_visit", latest_date: latest_record.end_date
    end
  end

  # Remove non-standard spaces and dashes and replace with ascii?
  #
  def shoehorn_name
    name.split(/\s/).map {|n| 
      n.split('-').map { |nn| 
        nn.capitalize }.join("-")}.join(" ")
  end
end
