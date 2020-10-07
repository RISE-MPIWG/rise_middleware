class Power
  include Consul::Power

  def initialize(user)
    @user = user
  end

  include Powers::Roles
  include Powers::Documents
  include Powers::Users
  include Powers::Resources
  include Powers::Collections
  include Powers::Sections
  include Powers::ContentUnits
  include Powers::ResearchTools
  include Powers::Organisations
  include Powers::UserLogs
  include Powers::Corpora
  include Powers::ToolExports

  # other

  power :homepage do
    true
  end
end
