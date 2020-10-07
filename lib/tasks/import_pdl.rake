namespace :import do
  desc 'import digital persian collections from /corpora/pdl into rise database'
  task :import_pdl do
    @organisation = find_or_create_by(name: "Roshan Institute for Persian Studies", slug: "rips")
    @collection = find_or_create_by(name: 'Persian Digital Collection', slug: 'pdl', organisation_id: @organisation.id)

    Pathname.new().children.select { |c| c.directory? }.collect { |p| p.to_s }
  end
end
