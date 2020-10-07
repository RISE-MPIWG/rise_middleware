require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's confiugred to server Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'SHINE API',
        version: 'v1',
        description: 'The SHINE API allows access to various resources made available by resource providers such as Stadt Bibliotek Berlin or the Chinese Text Project.',
        contact: {
          name: 'Pascal Belouin',
          email: 'pbelouin@mpiwg-berlin.mpg.de'
        }
      },
      tags: [
        {
          name: 'Collections',
          description: 'Collection Routes'
        },
        {
          name: 'Resources',
          description: 'Resource Routes'
        },
        {
          name: 'Sections',
          description: 'Section Routes'
        },
        {
          name: 'Content Units',
          description: 'Content Unit Routes'
        },
        {
          name: 'Corpora',
          description: 'Corpus Routes'
        },
        {
          name: 'ResearchTools',
          description: 'Research Tool Routes'
        },
        {
          name: 'ToolExports',
          description: 'Tool Export Routes'
        },
        {
          name: 'Sessions',
          description: 'Authentication Routes'
        }
      ],
      host: 'rise.mpiwg-berlin.mpg.de',
      schemes: ['https'],
      paths: {},
      securityDefinitions: {
        apiToken: {
          type: :apiKey,
          in: :header,
          name: 'RISE-API-TOKEN'
        }
      },
      definitions: {
        response: {
          type: "object",
          properties: {
            code: {
              type: "integer",
              format: "int32"
            },
            type: {
              type: "string"
            },
            message: {
              type: "string"
            }
          }
        },
        collection: {
          type: :object,
          properties: {
            uuid: { type: :string },
            name: { type: :string }
          }
        },
        resource: {
          type: :object,
          properties: {
            uuid: { type: :string, description: 'the Rise unique identifier for this resource' },
            name: { type: :string },
            uri: { type: :string, description: 'the original uri from which the resource can be fetched' }
          }
        },
        resource_for_index: {
          type: :object,
          properties: {
            uuid: { type: :string },
            name: { type: :string },
            collection_uuid: { type: :string }
          }
        },
        metadata: {
          type: :object,
          properties: {
            author: { type: :string },
            language: { type: :string }
          }
        },
        section: {
          type: :object,
          properties: {
            uuid: { type: :string, description: 'the Rise unique identifier for this section' },
            name: { type: :string },
            parentUuid: { type: :string, "x-nullable" => true },
            uri: { type: :string, description: 'the original uri from which the section can be fetched' }
          }
        },
        # docusky_section: {
        #   type: :object,
        #   properties: {
        #     corpus: { type: :string },
        #     files: {
        #       items: {
        #         type: :object,
        #         properties: {
        #           filename: { type: :string },
        #           content: { type: :string }
        #         }
        #       }
        #     }
        #   }
        # },
        content_unit: {
          type: :object,
          properties: {
            name: { type: :string },
            uuid: { type: :string },
            contents: { type: :string }
          }
        },
        corpus: {
          type: :object,
          properties: {
            uuid: { type: :string },
            name: { type: :string }
          }
        },
        research_tool: {
          type: :object,
          properties: {
            name: { type: :string },
            description: { type: :string },
            url: { type: :string }
          }
        },
        tool_export: {
          type: :object,
          properties: {
            uuid: { type: :string },
            name: { type: :string },
            file_url: { type: :string }
          }
        },
        research_tool_url_generation_params: {
          type: :object,
          properties: {
            section_uuids: {
              type: :array,
              description: 'Rise section uuids',
              items: {
                type: :string
              }
            },
            original_section_uuids: {
              type: :array,
              description: 'Original section uuids, as stored by the resource provider',
              items: {
                type: :string
              }
            },
            original_resource_uuid: {
              type: :string,
              description: 'Original resource uuid, needed when providing original_section_uuids in case the required sections have not been indexed yet by Rise'
            }
          }
        },
        metadata_for_tool_export_upload: {
          type: :object,
          properties: {
            name: { type: :string },
            notes: { type: :string },
            file_data_uri: { type: :string },
            section_uuids: {
              type: :array,
              items: {
                type: :string
              }
            }
          }
        },
        metadata_from_rp_instance: {
          type: :object,
          properties: {

          }
        },
        user_for_sign_in: {
          type: :object,
          properties: {
            email: { type: :string },
            password: { type: :string }
          }
        },
        sign_in_response: {
          type: :object,
          properties: {
            auth_token: { type: :string }
          }
        },
        user_credentials: {
          type: :object,
          properties: {
            user: {
              '$ref' => '#/definitions/user_for_sign_in'
            }
          }
        }
      }
    }
  }
end
