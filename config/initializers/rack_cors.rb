  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins do |source, _env|
        ResearchTool.where('url  ~* ?', "^#{source}").exists?
      end
      resource '*', headers: :any, methods: %i{get post put delete options}, expose: ['X-Page, X-Per-Page', 'X-Total', 'Link'], credentials: true
    end
  end
