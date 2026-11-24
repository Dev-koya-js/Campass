# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "stores a lowercased address and the organizational domain" do
    user = User.create!(email: " Student@g.ecc.u-tokyo.ac.jp ", password: "password")

    assert_equal "student@g.ecc.u-tokyo.ac.jp", user.email
    assert_equal "u-tokyo.ac.jp", user.university_domain
    assert_nil user.confirmed_at
  end

  test "uses the email domain when the address is already the organizational domain" do
    user = User.create!(email: "student@u-tokyo.ac.jp", password: "password")

    assert_equal "u-tokyo.ac.jp", user.university_domain
  end

  test "maps waseda and keio addresses, including subdomains, to the exception domain" do
    waseda = User.create!(email: "student@fuji.waseda.jp", password: "password")
    keio = User.create!(email: "student@keio.jp", password: "password")

    assert_equal "waseda.jp", waseda.university_domain
    assert_equal "keio.jp", keio.university_domain
  end

  test "derives the university from the email when a domain is supplied directly" do
    user = User.create!(
      email: "student@u-tokyo.ac.jp",
      password: "password",
      university_domain: "waseda.jp"
    )

    assert_equal "u-tokyo.ac.jp", user.university_domain
  end

  test "rejects an address outside accepted university domains" do
    user = User.new(email: "student@gmail.com", password: "password")

    assert_not user.valid?
    assert_includes user.errors[:email], "must be a university email address"
  end

  test "rejects an address that has no organization under ac.jp" do
    user = User.new(email: "student@ac.jp", password: "password")

    assert_not user.valid?
    assert_includes user.errors[:email], "must be a university email address"
  end

  test "rejects a duplicate address regardless of case" do
    User.create!(email: "student@u-tokyo.ac.jp", password: "password")
    duplicate = User.new(email: "STUDENT@u-tokyo.ac.jp", password: "password")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "requires a password" do
    user = User.new(email: "student@u-tokyo.ac.jp")

    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end
end
