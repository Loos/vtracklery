class SurveySeeder
  def self.seed
    if block_given? then xml_seed { yield }
    else xml_seed
    end
  end

  def self.xml_seed
    xml_text = File.read('db/xml/surveys.xml')
    unless xml_text.blank?
      if block_given? then
        Survey.load_from_xml_collection(xml_text) { yield }
      else
        Survey.load_from_xml_collection(xml_text)
      end
    end
  end
end

if __FILE__ == $0
  SurveySeeder.seed
end

