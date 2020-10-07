module PrettyXmlHelper
  def pp_xml(xml='')
    doc = Nokogiri.XML(xml) do |config|
      config.default_xml.noblanks
    end
     doc.to_xml(:indent => 2)
  end

end
