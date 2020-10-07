class EsukhiaResourcesService
  attr_reader :client, :collection

  def self.refresh_resources(collection)
    new(collection).refresh_resources
  end

  def initialize(collection)
    @collection = collection
    @client = EsukhiaClient.new
  end


  def refresh_resources
    resources = @client.fetch_resources.select { |i| i.name[/\.txt$/] }.find_all { |i| i.name.length > 20 }.group_by { |i| i.name[0,15] }
    save_resources(resources)
  end


  def save_resources(resources)
    resources.each do |key, sections|

      language = 'bo'
      @resource = @collection.resources.build(metadata: { dublincore: {language: language} })

      resource_name = []

      sections.each do |sec|
        file = open(sec.download_url).read
        firstline = file.split("\n").first.chomp
        resource_name.push(firstline)
        language = define_language(sec)
        section = @resource.sections.build(name: firstline, uri: sec.download_url, metadata: { dublincore: {language: language} })

        # file.each_line do |line|
        #   unless line.empty? || line =~ /\A\s*\Z/
        #     section.content_units.build(content: line)
        #   end
        # end

        section.save
      end

      @resource.update_attributes(name: resource_name[1])
      @resource.save(validate: false)
    end

  end

  def define_language(section)
    language = section.name.split('.')[0].split('-')[3]
    if language == 'BOD'
      language = 'bo'
    elsif language == 'ENG'
      language = 'en-GB'
    else
      language = nil
    end
  end

end
