class RemoteResourcesMatcherService

  def initialize(collection)
    @collection = collection
    @client = StandardClient.new(collection.api_url, collection.admin_api_key)
  end

  def match_resources
    remote_collection = @client.fetch_collection(@collection.original_uuid)

    # it compares the  updated_at timestamps of remote collection
    # with remote_updated_at of cached collection
    if remote_collection['updated_at'] > @collection.remote_updated_at
      # it goes through all cached resources of the collection and
      # compares the remote_updated_at timestamps with updated_at of
      # remote counterpart
      cached_resources = @collection.resources
      remote_resources = @client.fetch_resources("collections/#{@collection.original_uuid}/resources")

      original_uuids = remote_resources.map {|rr| rr['uuid']}
      cached_original_uuids = cached_resources.map {|rr| rr['original_uuid']}

      removed_resources_original_uuids = cached_original_uuids - original_uuids
      new_original_uuids = original_uuids - cached_original_uuids

      # we delete the resources that have been removed from the rp
      Resource.where(original_uuid: removed_resources_original_uuids).destroy_all

      remote_resources.each do |remote_resource|
        
        # we skip the deleted ones
        if removed_resources_original_uuids.include? remote_resource['uuid']
          next
        end

        # we create the new ones
        if new_original_uuids.include? remote_resource['uuid']
          remote_resources_to_create = remote_resources.select{ |rr| rr['uuid'] == remote_resource['uuid'] }
          @collection.resources.create!(remote_resources_to_create)
          next
        end

        cached_version = cached_resources.find_by(original_uuid: remote_resource['uuid'])
        if remote_resource['updated_at'] > cached_version.remote_updated_at
          remote_resource.delete('updated_at')
          remote_resource.delete('uuid')
          cached_version.update_attributes remote_resource
          cached_version.save
          cached_version.sections.delete_all
          # we need also to empty the metadata and fetch it again
        end
      end
    else
      puts "remote collection wasn't changed"
    end
  end
end
