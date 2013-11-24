# Be sure to restart your server when you modify this file.

if Rails.env.test?
  HostedForums::Application.config.session_store :cookie_store, 
    key: '_hosted_forums_session',
    domain: 'example.com'
else
  HostedForums::Application.config.session_store :cookie_store, 
    key: '_hosted_forums_session',
    domain: 'foremapp.com'
end