class RemoteCollectionsMatcherService

  def initialize(organisation)
    @organisation = organisation
    @client = StandardClient.new(organisation.api_url)
  end

  def match_collections
    remote_collections = @client.fetch_collections

    cached_collections = @organisation.collections

    original_uuids = remote_collections.map {|rr| rr['uuid']}
    cached_original_uuids = cached_collections.map {|rr| rr['original_uuid']}

    removed_collections_original_uuids = cached_original_uuids - original_uuids
    new_original_uuids = original_uuids - cached_original_uuids

    Collection.where(original_uuid: removed_collections_original_uuids).destroy_all

    new_remote_collections = remote_collections.select {|rc| new_original_uuids.include? rc["uuid"]}

    new_remote_collections.each do |remote_collection|
      @organisation.collections.create({name: remote_collection['name'], original_uuid: remote_collection['uuid'], api_url: @organisation.api_url, api_mapping_module: 'standard' })
      @organisation.save!
      @organisation.reload
    end

    fetch_resources_for_new_collections

  end

  def fetch_resources_for_new_collections
    @organisation.collections.each do |collection|
      RemoteResourcesService.refresh_resources(collection.id)
    end
  end

end
