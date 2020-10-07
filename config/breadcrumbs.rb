# crumb :root do
#   link I18n.t('home.home'), root_path
# end
# 
# crumb :welcome do
#   link I18n.t('welcome_to_rise'), root_path
# end

crumb :resources do
  link I18n.t('catalog'), resources_path
end

crumb :resource do |resource|
  link resource.full_name.truncate(110), resource
  parent :resources
end

crumb :corpus do |corpus|
  link "#{I18n.t('my')} #{Corpus.model_name.human(count: 1)}", [corpus, Resource]
end

crumb :corpus_resources do |corpus|
  link Resource.model_name.human(count: 2), [corpus, Resource]
  parent :corpus, corpus
end

crumb :corpus_tools do |corpus|
  link I18n.t('tools'), [:tools, corpus]
  parent :corpus, corpus
end

crumb :corpus_properties do |corpus|
  link I18n.t('properties'), [:edit, corpus]
  parent :corpus, corpus
end

crumb :corpus_resource do |corpus, resource|
  link resource.full_name.truncate(110), [corpus, resource]
  parent :corpus_resources, corpus
end

crumb :collections do
  link Collection.model_name.human(count: 2), Collection
end

crumb :admin do
  link I18n.t('admin_nav'), [:admin, Collection]
end

crumb :admin_collections do
  link Collection.model_name.human(count: 2), [:admin, Collection]
  parent :admin
end

crumb :admin_collection do |collection|
  link collection.name, [:admin, collection, Resource]
  parent :admin_collections
end

crumb :admin_collection_new do
  link I18n.t('action.create'), new_admin_collection_path
  parent :admin_collections
end

crumb :admin_collection_properties do |collection|
  link I18n.t('properties'), admin_collection_path(collection)
  parent :admin_collection, collection
end

crumb :admin_collection_resources do |collection|
  link Resource.model_name.human(count: 2), [:admin, collection, Resource]
  parent :admin_collection, collection
end

crumb :admin_collection_resource do |collection, resource|
  link resource.to_s.truncate(110), [:admin, collection, resource]
  parent :admin_collection_resources, collection
end

crumb :admin_collection_organisations do |collection|
  link I18n.t('action.manage_organisation_access'), manage_organisation_access_admin_collection_path(collection)
  parent :admin_collection, collection
end

crumb :admin_collection_organisations_edit do |collection, organisation|
  link organisation.name, edit_admin_collection_organisation_path(collection, organisation)
  parent :admin_collection_organisations, collection
end

crumb :admin_research_tools do
  link ResearchTool.model_name.human(count: 2), [:admin, ResearchTool]
  parent :admin
end

crumb :admin_research_tool do |research_tool|
  link research_tool, manage_access_admin_research_tool_path(research_tool)
  parent :admin_research_tools
end

crumb :admin_research_tool_new do
  link I18n.t('action.create'), new_admin_research_tool_path
  parent :admin_research_tools
end

crumb :admin_research_tool_organisations do |research_tool|
  link I18n.t('action.manage_organisation_access'), manage_access_admin_research_tool_path(research_tool)
  parent :admin_research_tool, research_tool
end

crumb :admin_research_tool_edit do |research_tool|
  link I18n.t('properties'), edit_admin_research_tool_path(research_tool)
  parent :admin_research_tool, research_tool
end

crumb :admin_users do
  link User.model_name.human(count: 2), [:admin, User]
  parent :admin
end

crumb :admin_user do |user|
  link user, user
  parent :admin_users
end

crumb :admin_organisations do
  link Organisation.model_name.human(count: 2), [:admin, Organisation]
  parent :admin
end

crumb :admin_organisation do |organisation|
  link organisation.name, [:admin, organisation]
  parent :admin_organisations
end

crumb :admin_organisation_edit do |organisation|
  link I18n.t('action.edit'), edit_admin_organisation_path(organisation)
  parent :admin_organisation, organisation
end

crumb :admin_organisation_new do
  link I18n.t('action.create'), new_admin_organisation_path
  parent :admin_organisations
end

crumb :admin_user_logs do
  link UserLog.model_name.human(count: 2), [:admin, UserLog]
  parent :admin
end

crumb :admin_monitor_jobs do
  link I18n.t('monitor_jobs'), admin_monitor_jobs_path
  parent :admin
end

crumb :doc do
  link I18n.t('documentation'), doc_for_developers_pages_path
end

crumb :doc_for_research_tool_developers do
  link I18n.t('for_research_tool_developers'), doc_for_resource_providers_pages_path
  parent :doc
end

crumb :doc_for_resource_providers do
  link I18n.t('for_resource_providers'), doc_for_developers_pages_path
  parent :doc
end

crumb :my_account do |user|
  link I18n.t('edit_account'), edit_user_registration_path(user)
end

crumb :login do
  link I18n.t('.sign_in', default: 'Sign in'), new_user_session_path
end
