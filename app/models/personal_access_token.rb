# frozen_string_literal: true

# Personal Access Token class
class PersonalAccessToken < ApplicationRecord
  serialize :scopes, Array

  attr_reader :token

  belongs_to :user

  before_save :ensure_token

  validates :scopes, presence: true

  def revoke!
    update!(revoked: true)
  end

  def revoked?
    revoked == true
  end

  def expires?
    expires_at.present?
  end

  def expired?
    expires? && expires_at <= Time.current
  end

  def active?
    !revoked? && !expired?
  end

  def self.find_by_token(token)
    token_digest = Devise.token_generator.digest(self, :token_digest, token)

    find_by(token_digest:)
  end

  private

  def write_new_token
    @token, self.token_digest = Devise.token_generator.generate(self.class, :token_digest)
  end

  def ensure_token
    write_new_token if token_digest.blank?
  end
end
