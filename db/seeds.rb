require 'faker'

load_fake_data = false
load_ctext = false

ActiveRecord::Base.transaction do
  ActsAsTaggableOn::Tagging.delete_all
  ActsAsTaggableOn::Tag.delete_all
  User.delete_all
  Organisation.delete_all
  ContentUnit.delete_all
  Section.delete_all
  Resource.delete_all
  Collection.delete_all
  OrganisationCollection.delete_all
  ResearchTool.delete_all
  OrganisationResearchTool.delete_all
  UserLog.delete_all
end

organisations = Organisation.create(
  [
    {
      name: 'Max Planck Institute for the History of Science',
      slug: :mpiwg,
      organisation_type: :research_institute,
      api_url: 'https://rise-rp.mpiwg-berlin.mpg.de/api',
      default_collection_access_type: :public_access,
      api_mapping_module: :standard
    },
    {
      name: 'Esukhia',
      slug: :esukhia,
      organisation_type: :research_institute,
      default_collection_access_type: :public_access,
      api_mapping_module: :esukhia
    },
    {
      name: 'Rise Admin',
      slug: :rise_admin,
      organisation_type: :research_institute
    },
    {
      name: 'Heidelberg University',
      slug: :heidelberg,
      organisation_type: :university,
      default_collection_access_type: :public_access,
      api_mapping_module: :standard
    },
    {
      name: 'Guest Organisation',
      slug: :guest_org,
      organisation_type: :research_institute
    },
    {
      name: 'Leiden University',
      slug: :leiden,
      organisation_type: :university
    },
    {
      name: 'Perseus Digital Library',
      slug: :perseus,
      organisation_type: :university
    },
    {
      name: 'Chinese Text Project',
      slug: :ctext_org,
      organisation_type: :research_institute
    },
    {
      name: 'National Taiwan University',
      slug: 'ntu',
      organisation_type: :university,
      api_key: 'NTU API KEY GOES HERE',
      api_url: 'http://thdlapi.digital.ntu.edu.tw',
      api_mapping_module: :standard
    },
    {
      name: 'Kanseki Repository',
      slug: :kanseki,
      organisation_type: :public_vendor
    },
    {
      name: 'beta masaheft',
      slug: :betamasaheft,
      organisation_type: :university,
      api_url: 'https://betamasaheft.eu/shine/api/',
      api_mapping_module: :standard,
      default_collection_access_type: :public_access
    },
    {
      name: 'Chinese Buddhist Electronic Text Association',
      slug: :cbeta,
      organisation_type: :public_vendor,
      api_url: 'http://cbdata.dila.edu.tw/v1.2/api',
      api_mapping_module: :standard,
      default_collection_access_type: :public_access
    },
    {
      name: 'Staatsbibliothek zu Berlin',
      slug: :sbb,
      organisation_type: :library,
      api_url: 'https://localgazetteers-test.mpiwg-berlin.mpg.de/4rise',
      api_mapping_module: :standard,
      default_collection_access_type: :private_access
    }
  ]
)

users = User.create(
  [
    {
      email: 'super_user@your_org.com',
      password: 'password',
      organisation: Organisation.find_by(slug: :rise_admin),
      role: :super_admin
    }
  ]
)

research_tools = ResearchTool.create([{
                                       name: "MARKUS",
                                       description: "MARKUS allows you to tag personal names, place names, temporal references, and bureaucratic offices automatically. You can also upload your own list of key terms for automated tagging. You can then read a document while checking a range of reference works at the same time, or compare passages in which the same names or keywords appear. Or, you can extract the information you have tagged and use it for further analysis in our visualization platform and other tools.",
                                       slug: :markus,
                                       url: 'https://dh.chinese-empires.eu/markus/beta'
                                     }])

organisation_research_tools = OrganisationResearchTool.create([
                                                                {
                                                                  organisation: Organisation.find_by(slug: :mpiwg),
                                                                  research_tool: ResearchTool.find_by(slug: :markus),
                                                                  access_right: :enabled
                                                                },
                                                                {
                                                                  organisation: Organisation.find_by(slug: :ntu),
                                                                  research_tool: ResearchTool.find_by(slug: :markus),
                                                                  access_right: :enabled
                                                                },
                                                                {
                                                                  organisation: Organisation.find_by(slug: :leiden),
                                                                  research_tool: ResearchTool.find_by(slug: :markus),
                                                                  access_right: :enabled
                                                                }
                                                              ])

collections = Collection.create(
  [
    {
      created_by: User.find_by(email: 'matthias.kaun@sbb.spk-berlin.de'),
      organisation: Organisation.find_by(slug: :stabi),
      name: 'Zhongguo Fangzhi Ku (Local Gazeteers Database by Erudition)',
      slug: :lg,
      api_mapping_module: :standard,
      api_url: "https://localgazetteers-test.mpiwg-berlin.mpg.de/4rise",
      resources_url: "https://localgazetteers-test.mpiwg-berlin.mpg.de/4rise/resources/"
    },
    {
      created_by: User.find_by(email: 'djs@dsturgeon.net'),
      organisation: Organisation.find_by(slug: :ctext_org),
      name: 'Chinese Text Project',
      slug: :ctext,
      api_mapping_module: :ctext,
      api_url: "https://api.ctext.org/",
      resources_url: "http://api.ctext.org/gettext?urn="
    },
    {
      created_by: User.find_by(email: 'cwittern@gmail.com'),
      organisation: Organisation.find_by(slug: :kanseki),
      name: 'Kanseki Repository',
      slug: :kanripo,
      api_mapping_module: :kanripo,
      api_url: "",
      access_type: :public_access
    },
    {
      created_by: User.find_by(email: 'elie.roux@telecom-bretagne.eu'),
      organisation: Organisation.find_by(slug: :esukhia),
      name: 'Esukhia',
      slug: :esukhia,
      api_mapping_module: :esukhia,
      api_url: "",
      access_type: :public_access
    },
    {
      created_by: User.find_by(email: 'gregory.crane@tufts.edu'),
      organisation: Organisation.find_by(slug: :perseus),
      name: 'Perseus 4.0',
      slug: :perseus,
      api_mapping_module: :perseus,
      api_url: "",
      access_type: :public_access
    }
  ]
)

organisation_collections = OrganisationCollection.create([
                                                           {
                                                             organisation: Organisation.find_by(slug: :rise_admin),
                                                             collection: Collection.find_by(slug: :ctext),
                                                             access_right: :read,
                                                             api_key: 'CTEXT_API_KEY_GOES_HERE'
                                                           }
                                                         ])

if load_ctext
  # load ctext index
  ctext_manager = ManageCtextCollection.new
  ctext_manager.update_resources_list
end

# fake data

if load_fake_data
  fake_organisations = []
  40.times do |index|
    fake_organisations << {
      name: Faker::University.name,
      slug: "slug#{index}",
      organisation_type: %i[library research_institute vendor university].sample
    }
  end
  Organisation.create(fake_organisations)

  fake_users = []
  50.times do |_index|
    fake_users << {
      email: Faker::Internet.email,
      password: 'password',
      organisation: Organisation.all.sample,
      role: %i[admin super_admin standard_user].sample
    }
  end

  User.create(fake_users)

  fake_collections = []
  200.times do
    user = User.all.sample
    fake_collections <<
      {
        created_by: user,
        organisation: user.organisation,
        name: "#{Faker::Book.title} - #{Faker::Book.publisher}"
      }
  end
  Collection.create(fake_collections)

  fake_resources = []
  500.times do
    user = User.all.sample
    fake_resources << {
      created_by: user,
      organisation: user.organisation,
      name: Faker::Book.title,
      uri: 'http://www.ucl.ac.uk/museums-static/digitalegypt/literature/religious/bd30a.html',
      collection: Collection.all.sample
    }
  end
  Resource.create(fake_resources)
end
