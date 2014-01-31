module Event::XmlExtensions
  extend ActiveSupport::Concern

  #included do
  #end

  module ClassMethods
    #
    # Import Event data from XML generated by
    # Events#index.xml.builder
    #
    def load_from_xml_collection(xml_text)
      items = parse_xml_collection(xml_text)
      items.each do |item|
        if block_given? then self.create(item) { |i| yield(i) }
        else self.create(item)
        end
      end
    end

    #
    # Import Event data from XML generated by
    # Events#show.xml.builder
    #
    def load_from_xml(xml_text)
      item = parse_xml(xml_text)
      if block_given? then self.create(item) { |i| yield(i) }
      else self.create(item)
      end
    end

    #
    # Uses the built in Hash.from_xml() function to easily import an xml
    # document into an unwieldy hash object.
    # Pass the hash to get_hash_array_from_xml_object() in order to make
    # the data more manageable.
    #
    def parse_xml_collection(xml_text)
      hash = Hash.from_xml(replace_tags(xml_text))
      return get_hash_array_from_xml_object(hash, "event")
    end

    #
    # Uses the built in Hash.from_xml() function to easily import an xml
    # document into an unwieldy hash object.
    # Pass the hash to get_hash_array_from_xml_object() in order to make
    # the data more manageable.
    #
    def parse_xml(xml_text)
      hash = Hash.from_xml(replace_tags(xml_text))
      return get_hash_from_xml_object(hash, "event")
    end

    #
    # Replace normal xml tags with ones that support
    # Model.accepts_nested_attributes_for
    #
    def replace_tags(xml_text)
      #doc = Nokogiri::XML(xml_text)
      #return doc.to_xml
      return xml_text
    end

    #
    # Return true if xml is valid xml and conforms to expectations about an
    # array of event xml objects
    #
    def is_xml_valid?(xml_text)
      return true #FIXME
    end

    #
    # When xml is read from Hash.from_xml(), it is parsed into a peculiar
    # structure of hashes and arrays.  This method gets the essential hash
    # array from this structure which can be used to create an ActiveRecord
    # object.
    #
    def get_hash_array_from_xml_object(obj, name)
      plural_name = name.downcase.pluralize # eg. 'events' or 'items'

      case obj[plural_name]
      when Array
        #
        # When the array type is set in XML eg. <plural_name type="array">
        # instead of returning a hash of sub objects, it simply returns
        # the array of hashes that we need.
        #
        return obj[plural_name]
      when Hash
        #
        # When the array type is NOT set in XML eg. <plural_name>
        # The root hash points to another hash, which includes the key
        # :singular_name, whose value is the array of hashes we need.
        #
        singular_obj = obj[plural_name]
        return get_hash_from_xml_object(singular_obj, name)
      else # Something went wrong...
        raise "Bad object: not array or hash repsonding to '#{plural_name}': #{obj.inspect}"
      end
    end # def get_hash_array_from_xml_object(obj, name)

    #
    # When xml is read from Hash.from_xml(), it is parsed into a peculiar
    # structure of hashes and arrays.  This method gets the essential hash
    # object from this structure which can be used to create an ActiveRecord
    # object.
    #
    def get_hash_from_xml_object(obj, name)
      case obj[name.downcase]
      when Array
        return obj[name.downcase]
      when Hash
        # When there is only one item in the collection, Hash.from_xml
        #  creates a hash relationship rather than an array.
        return [ obj[name.downcase] ]
      else # Something went wrong...
        raise "Bad object: does not respond to '#{name.downcase}': #{obj.inspect}"
      end
    end # def get_hash_from_xml_object(obj, name)

  end # module ClassMethods

end # module XmlExtensions
