Warden::Strategies.add(:password) do
  def subdomain
    ActionDispatch::Http::URL.extract_subdomains(request.host, 1)
  end

  def valid?
    subdomain.present? && params["user"]
  end

  def authenticate!
    if account = Subscribem::Account.where(:subdomain => subdomain).first
      if u = account.users.where(:email => params["user"]["email"]).first
        if u.authenticate(params["user"]["password"])
          return success!(u)
        end
      end
    end

    fail!
  end
end