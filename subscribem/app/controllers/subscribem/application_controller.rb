module Subscribem
  class ApplicationController < ::ApplicationController
    def force_authentication!(account, user)
      env['warden'].set_user(user.id, :scope => :user)
      env['warden'].set_user(account.id, :scope => :account)
    end
  end
end
