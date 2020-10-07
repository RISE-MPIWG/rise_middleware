class RpRegistrationService
  attr_reader :rp_url, :organisation_name, :user_email

  def initialize(rp_url, organisation_name, user_email)
    # @rp_url = rp_url
    @rp_url = 'http://docker.for.mac.host.internal:4000'
    @organisation_name = organisation_name
    @user_email = user_email
  end

  def register
  	auth = { organisation_name: organisation_name, user_email: user_email }
    user = User.from_rp_registration(auth)
    organisation = user.organisation
    organisation.api_url = @rp_url + '/api'
    organisation.api_mapping_module = :standard
    organisation.save
    rcs = RemoteCollectionsService.new(organisation.id)
    rcs.refresh_collections
    organisation.collections.each do |collection|
      attributes = {}
      attributes[:collection_id] = collection.id
      attributes[:user_id] = user.id
      RefreshCollectionResourcesJob.perform_later(attributes)
    end
  end

end
