# frozen_string_literal: true

class Company < ActiveRecord::Base
  after_create :create_tenant
  before_destroy :drop_tenant

  validates :name, :subdomain, presence: { message: 'Zadejte' }

  private

    def create_tenant
      Apartment::Tenant.create(subdomain)
      Apartment::Tenant.switch(subdomain) do
        Redmine::DefaultData::Loader.load('cs')

        User.create(
          firstname: "Redmine",
          lastname: "Admin",
          mail: "admin@example.net",
          mail_notification: 'none',
          status: 1,
          login: 'admin',
          hashed_password: "76d1379d983b039ca3e7c6c8c2fbd825f64ad666",
          salt: "e47ae808eb2dc3822ac8a7c5e7118471",
          # password: '12345678',
          # password_confirmation: '12345678',
          must_change_passwd: true,
          admin: true,
          disable_security_notification: true
        )
      end
    end

    def drop_tenant
      Apartment::Tenant.drop(subdomain)
    end
end
