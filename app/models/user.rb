# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  xasia_token            :string           default(""), not null
#  preferred_language     :integer
#  role                   :integer
#  archived               :boolean          default(FALSE)
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  organisation_id        :bigint(8)
#  auth_token             :string
#  token_created_at       :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  uid                    :string
#

class User < ApplicationRecord
  include Archivable
  acts_as_tagger

  LANGUAGES = { "en" => 0, "de" => 1, "zh-CN" => 2 }.freeze

  after_create :generate_auth_token, :generate_corpus
  # before_create :default_organisation

  enum preferred_language: LANGUAGES

  ROLES = { super_admin: 0, admin: 1, standard_user: 2 }.freeze

  enum role: ROLES

  def to_s
    email
  end

  scope :skip_user, ->(user) { where.not(id: user.id) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  belongs_to :organisation, inverse_of: :users, optional: true
  has_many :user_logs, as: :loggable, dependent: :destroy

  has_many :corpora, foreign_key: :created_by_id

  has_many :tool_exports

  def default_organisation
    self.organisation_id ||= Organisation.find_by_slug(:guest_org).id
  end

  def generate_auth_token
    token = SecureRandom.hex
    update_columns(auth_token: token, token_created_at: Time.zone.now)
    token
  end

  def generate_corpus
    corpora.create(
      name: "#{I18n.t('my')} #{Corpus.model_name.human(count: 1)}"
    )
  end

  def invalidate_auth_token
    update_columns(auth_token: nil, token_created_at: nil)
  end

  def colleagues
    organisation.users
  end

  def access_right_for_model(model)
    return :public_access if model.public_access?
    return nil if model.nil?

    case model.class.to_s
    when "Resource"
      collection_id = model.collection_id
    when "Collection"
      collection_id = model.id
    end

    if Collection.find(collection_id).organisation_id == organisation_id
      return :owner
    end

    organisation_collection = OrganisationCollection.find_by(organisation_id: organisation_id, collection_id: collection_id)
    if organisation_collection.present?
      organisation_collection.access_right.to_sym
    else
      OrganisationCollection.access_rights.first.first.to_sym
    end
  end

  def has_access_to?(model)
    case access_right_for_model(model)
    when :public_access, :owner, :read
      true
    else
      false
    end
  end

  # use delayed jobs for devise
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.from_shibboleth(auth)
    return if auth[:eppn].empty?
    where(email: auth[:eppn]).first_or_create do |user|
      user.email = auth[:eppn]
      password = Devise.friendly_token[0, 20]
      user.password = password
      UserMailer.registration_confirmation_notification(user.email, password).deliver_now
      user.organisation = Organisation.where(name: auth[:institution_display_name]).first_or_create do |organisation|
        organisation.name = auth[:institution_display_name]
        organisation.slug = auth[:institution_display_name].parameterize.underscore
      end
    end
  end

  def self.from_rp_registration(auth)
    where(email: auth[:user_email]).first_or_create do |user|
      user.email = auth[:user_email]
      password = Devise.friendly_token[0, 20]
      user.password = password
      UserMailer.registration_confirmation_notification(user.email, password).deliver_now
      if user.organisation.nil?
        user.organisation = Organisation.where(name: auth[:organisation_name]).first_or_create do |organisation|
          organisation.name = auth[:organisation_name]
          organisation.slug = auth[:organisation_name].parameterize.underscore
          organisation.save
        end
      end
    end
  end
end
