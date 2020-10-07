class EsukhiaSectionsService
  attr_reader :resource, :client

  def self.get_sections(resource)
    new(resource).get_sections
  end

  def initialize(resource)
    @resource = resource
  end

  def get_sections
    resource.sections
  end

end
