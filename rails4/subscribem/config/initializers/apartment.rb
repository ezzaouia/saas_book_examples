Apartment.excluded_models = ["Subscribem::Account",
                             "Subscribem::Member",
                             "Subscribem::User"]

Apartment.database_names = lambda{ Subscribem::Account.pluck(:subdomain) }