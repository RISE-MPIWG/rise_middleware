module Metadatable
  extend ActiveSupport::Concern
  LANGUAGES = { 
    "Arabic" => 'ar',
    "Traditional Chinese" => 'zh-Hant',
    "Latin" => 'lat',
    "Greek" => 'grc',
    "English" => 'en-GB',
    "French" => 'fr-FR',
    "German" => 'de-DE',
    "Tibetan" => 'bo'}.freeze
  METADATA_FIELDS_TO_IGNORE_FOR_DISPLAY = [
    'full_name',
    'level1',
    'level2',
    'latitude',
    'longitude',
    'totalPage',
    'dynasty',
    'tags',
    'lastmodified',
    'topurn',
    'edition',
    'title',
    'toptitle',
    'path',
    'error',
    'timestamp',
    'status',
    'source',
    'message'
  ]

  included do
    def cascading_metadata
      inherited_metadata = case self.class.to_s
                           when 'Collection'
                             convert_metadata(metadata)
                           when 'Resource'
                             convert_metadata(collection.cascading_metadata)
                           when 'Section'
                             convert_metadata(resource.cascading_metadata)
                           when 'ContentUnit'
                             convert_metadata(section.cascading_metadata)
                           end
      inherited_metadata.merge(convert_metadata(metadata)).with_indifferent_access
    end

    private

    def convert_metadata(metadata)
      if metadata.is_a?(String) || metadata.nil?
        {}
      else
        metadata
      end
    end

    def context
      {
        '@context' => {
          '@vocab' => 'https://rise.mpiwg-berlin.mpg.de/pages/doc_for_developers',
          dublincore: 'http://dublincore.org/specifications/dublin-core/dcmi-terms/2012-06-14/?v=terms',
          shine: 'https://rise.mpiwg-berlin.mpg.de/pages/doc_for_developers#shine_metadata'
        }
      }
    end

    def dublincore_hash
      {
        creator: '',
        contributors: [],
        coverage: '',
        date: '',
        description: '',
        format: '',
        identifier: '',
        language: '',
        publisher: '',
        relation: [],
        rights: '',
        source: '',
        subject: '',
        title: '',
        type: ''
      }
    end

    # dublincore 15 essential fields
    # creator: [:string],
    # contributors: [:string, array: true, default: []],
    # coverage: [:string],
    # date: [:date],
    # description: [:string],
    # format: [:string],
    # identifier: [:string],
    # language: [:string],
    # publisher: [:string],
    # relation: [:string, array: true, default: []],
    # rights: [:string],
    # source: [:string],
    # subject: [:string],
    # title: [:string],
    # type: [:string]

    # shine metadata fields
    # shine_content_unit_type
    # shine_resource_type
    # shine_section_type

    # extra fields



  end
end
