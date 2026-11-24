# frozen_string_literal: true

class User < ApplicationRecord
  # 学生メールが .ac.jp ではない大学。保存する識別子は、このドメインそのもの。
  EXCEPTION_DOMAINS = %w[waseda.jp keio.jp].freeze

  has_secure_password

  before_validation :normalize_identity

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :email_must_be_university_address

  def self.university_domain_for(email)
    domain = email.to_s.split("@", 2)[1]
    return if domain.blank?

    if domain.end_with?(".ac.jp")
      labels = domain.split(".")
      return if labels.any?(&:blank?) || labels.length < 3

      labels.last(3).join(".")
    else
      EXCEPTION_DOMAINS.find { |exception| domain == exception || domain.end_with?(".#{exception}") }
    end
  end

  private

  def normalize_identity
    self.email = email.to_s.strip.downcase.presence
    self.university_domain = self.class.university_domain_for(email)
  end

  def email_must_be_university_address
    return if email.blank? || errors[:email].any?
    return if university_domain.present?

    errors.add(:email, :university)
  end
end
