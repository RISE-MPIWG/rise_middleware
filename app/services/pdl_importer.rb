class PdlImporter
  COLLECTION_PATH = './corpora/pdl'

  def initialize
    @organisation = Organisation.find_or_create_by(name: "Roshan Institute for Persian Studies", slug: "rips")
    @collection = Collection.find_or_create_by(name: 'Persian Digital Collection', slug: 'pdl', organisation_id: @organisation.id)
  end

  def call
    clear_db!
  end

  def clear_db!
    res_ids = @collection.resources.map(&:id)
    sec_ids = Section.where(resource_id: res_ids)
    ContentUnit.where(section_id: sec_ids).delete_all
    Section.where(resource_id: res_ids).delete_all
    Resource.where(collection_id: @collection.id).delete_all
  end

  def import_resources
    Dir.glob(COLLECTION_PATH + "/*").each do |resource_folder|
      puts resource_folder
    end
  end
end
