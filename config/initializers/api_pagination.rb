ApiPagination.configure do |config|
  # By default, this is set to 'Total'
  config.total_header = 'X-Total'
  config.per_page_header = 'X-Per-Page'
  config.page_header = 'X-Page'
  config.per_page_param = :per_page
end
