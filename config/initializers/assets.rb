Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += ['node_modules/toastr/build/toastr.min.js']
Rails.application.config.assets.precompile += ['node_modules/toastr/build/toastr.min.css']
Rails.application.config.assets.precompile += %w( home.js )