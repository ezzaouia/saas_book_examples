Subscribem::Account.class_eval do
  def settings_for(user)
    Forem::Setting
      .where(account_id: self.id, user_id: user.id)
      .first_or_create!
  end
end
