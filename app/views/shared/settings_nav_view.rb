module Shared
  class SettingsNavView < ApplicationView

    def initialize(user:)
      @user = user
    end

    def template
      div(class: "group-data-[nav=modal]:-mt-4") do
        render ::SettingsNav::HeaderComponent.new do
          plain " General "
        end
      end

      ul do
        render(::SettingsNav::Nav.new(
          title: "Feedbin",
          subtitle: "Back to the app",
          url: helpers.root_path,
          icon: "menu-icon-app",
          classes: "md:hidden"
        ))
        render(::SettingsNav::Nav.new(
          title: "Settings",
          subtitle: "General preferences",
          url: helpers.settings_path,
          icon: "menu-icon-settings",
          selected: helpers.is_active?("settings", "settings")
        ))
        render(::SettingsNav::Nav.new(
          title: "Subscriptions",
          subtitle: "Manage feeds",
          url: helpers.settings_subscriptions_path,
          icon: "menu-icon-subscriptions",
          selected: helpers.is_active?(["settings/subscriptions"], %w[index edit])
        ))
        render(::SettingsNav::Nav.new(
          title: "Sources",
          subtitle: "Twitter, newsletters & pages",
          url: helpers.settings_newsletters_pages_path,
          icon: "menu-icon-newsletters",
          selected: helpers.is_active?("settings", "newsletters_pages")
        ))
      end

      render ::SettingsNav::HeaderComponent.new do
        plain " Tools"
      end

      div(class: "px-4 pl-10 tw-hidden group-data-[nav=dropdown]:block") do
        hr(class: "m-0")
      end

      ul do
        render(::SettingsNav::Nav.new(
          title: "Actions",
          subtitle: "Filters & more",
          url: helpers.actions_path,
          selected: helpers.is_active?(["actions"], %w[index new edit]),
          icon: "menu-icon-actions"
        ))
        render(::SettingsNav::Nav.new(
          title: "Share & Save",
          subtitle: "Social plugins",
          url: helpers.sharing_services_path,
          selected: helpers.is_active?("sharing_services", "index"),
          icon: "menu-icon-share-save"
        ))
        render(::SettingsNav::Nav.new(
          title: "Import & Export",
          subtitle: "Bring your OPML",
          url: helpers.settings_import_export_path,
          selected: helpers.is_active?(["settings/imports"], %w[index show]),
          icon: "menu-icon-import-export"
        ))
        if @user.try(:account_migrations)&.exists?
          render(::SettingsNav::Nav.new(
            title: "Account Migration",
            subtitle: "Howdy, Feed Wrangler",
            url: helpers.account_migrations_path,
            selected: helpers.is_active?("account_migrations", "index"),
            icon: "menu-icon-migration"
          ))
        end
      end

      render ::SettingsNav::HeaderComponent.new do
        plain " Admin"
      end

      div(class: "px-4 pl-10 tw-hidden group-data-[nav=dropdown]:block") do
        hr(class: "m-0")
      end

      ul do
        render(::SettingsNav::Nav.new(
          title: "Account",
          subtitle: "Update email & password",
          url: helpers.settings_account_path,
          selected: helpers.is_active?("settings", "account"),
          icon: "menu-icon-account"
        ))
        if ENV["STRIPE_API_KEY"]
          render(::SettingsNav::Nav.new(
            title: "Billing",
            subtitle: "Payment method & plan",
            url: helpers.settings_billing_path,
            selected: helpers.is_active?(["settings/billings"], %w[index edit payment_history]),
            icon: "menu-icon-billing"
          ))
        end
        if @user.try(:admin?)
          render(::SettingsNav::Nav.new(
            title: "Customers",
            subtitle: "Manage customers",
            url: helpers.admin_users_path,
            selected: helpers.is_active?("admin/users", "index"),
            icon: "menu-icon-customers"
          ))
          render(::SettingsNav::Nav.new(
            title: "Sidekiq",
            subtitle: "Background jobs",
            url: helpers.sidekiq_web_path,
            icon: "menu-icon-sidekiq"
          ))
          render(::SettingsNav::Nav.new(
            title: "Lookbook",
            subtitle: "Feedkit components",
            url: "/lookbook",
            icon: "menu-icon-lookbook"
          ))
        end
      end

      div(class: "px-4 pl-10 tw-hidden group-data-[nav=dropdown]:block") do
        hr(class: "m-0")
      end

      ul(class: "tw-hidden group-data-[nav=dropdown]:block") do
        render(::SettingsNav::Nav.new(
          title: "Log Out",
          url: [helpers.logout_path, { method: :delete }],
          icon: "menu-icon-log-out"
        ))
      end

      div(class: "group-data-[nav=dropdown]:hidden") do
        div(class: "p-4 group-data-[nav=modal]:py-0") { hr }
        ul do
          render ::SettingsNav::NavSmall.new url: "/home" do
            "Home"
          end
          render ::SettingsNav::NavSmall.new url: "/blog" do
            "Blog"
          end
          render ::SettingsNav::NavSmall.new url: "/apps" do
            "Apps"
          end
          render ::SettingsNav::NavSmall.new url: "/help" do
            "Help"
          end
          render ::SettingsNav::NavSmall.new url: "https://github.com/feedbin/feedbin-api#readme" do
            "API"
          end
          render ::SettingsNav::NavSmall.new url: "/privacy-policy" do
            "Privacy Policy"
          end
          render ::SettingsNav::NavSmall.new url: "mailto:support@feedbin.com" do
            "Email"
          end
          render ::SettingsNav::NavSmall.new url: "https://twitter.com/feedbin" do
            "Twitter"
          end
          render ::SettingsNav::NavSmall.new url: helpers.logout_path, method: "delete" do
            "Log Out"
          end
        end
      end
    end

  end
end
