# ActionMailer Config
if ENV["MAILER_DOMAIN_NAME"]
  ActionMailer::Base.default_url_options = { :host => ENV["MAILER_DOMAIN_NAME"] }
  ActionMailer::Base.delivery_method = ENV['MAILER_DELIVERY_METHOD'].nil? ? :file : ENV['MAILER_DELIVERY_METHOD'].to_sym
  ActionMailer::Base.smtp_settings = {
    address: ENV["MAILER_SMTP_HOST"],
    port: ENV['MAILER_SMTP_PORT'].nil? ? 587 : ENV['MAILER_SMTP_PORT'].to_i,
    domain: ENV["MAILER_DOMAIN_NAME"],
    authentication: ENV['MAILER_SMTP_AUTHENTICATION_METHOD'].nil? ? :login : ENV['MAILER_SMTP_AUTHENTICATION_METHOD'].to_sym,
    enable_starttls_auto: ENV['MAILER_SMTP_STARTTLS_AUTO'].nil? ? true : ENV['MAILER_SMTP_STARTTLS_AUTO'],
    user_name: ENV["MAILER_SMTP_USER_NAME"],
    password: ENV["MAILER_SMTP_PASSWORD"]
  }
end
