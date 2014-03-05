Forem.user_class.class_eval do
  # def forem_admin?(account)
  #   !!settings_for(account).get(:forem_admin)
  # end

  # private
  #   def settings_for(account)
  #     Forem::Setting.where(user_id: self.id, account_id: account.id).first_or_create!
  #   end
end
