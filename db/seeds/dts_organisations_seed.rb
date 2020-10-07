Organisations = Organisation.create!(
  [
    {
      name: 'The Alpheios Project',
      slug: :alpheios,
      organisation_type: :research_institute,
      api_url: 'http://texts.alpheios.net/api',
      default_collection_access_type: :public_access,
      api_mapping_module: :dts
    },
    {
      name: 'École des Chartes',
      slug: :ecole,
      organisation_type: :research_institute,
      api_url: 'https://dev.chartes.psl.eu/api/nautilus/',
      default_collection_access_type: :public_access,
      api_mapping_module: :dts
    },
    {
      name: 'Heidelberg Academy of Sciences and Humanities',
      slug: :edh,
      organisation_type: :research_institute,
      api_url: 'https://edh-www.adw.uni-heidelberg.de/api',
      default_collection_access_type: :public_access,
      api_mapping_module: :dts
    },
  ]
)
