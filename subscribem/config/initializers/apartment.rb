Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'

Apartment.excluded_models = ["Subscribem::Account",
                             "Subscribem::Member",
                             "Subscribem::User"]