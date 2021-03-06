class WorkTimeSeeder
  def self.seed
    if block_given? then xml_seed { yield }
    else xml_seed
    end
  end

  def self.xml_seed
    xml_text = File.read('db/xml/work_times.xml')
    unless xml_text.blank?
      if block_given? then
        WorkTime.load_from_xml_collection(xml_text) { yield }
      else
        WorkTime.load_from_xml_collection(xml_text)
      end
    end
  end
end

if __FILE__ == $0
  WorkTimeSeeder.seed
end

