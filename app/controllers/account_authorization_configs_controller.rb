#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

class AccountAuthorizationConfigsController < ApplicationController
  before_filter :require_context, :require_root_account_management

  def index
    @account_configs = @account.account_authorization_configs.to_a
    while @account_configs.length < 2
      @account_configs << @account.account_authorization_configs.new
    end
    @saml_identifiers = Onelogin::Saml::NameIdentifiers::ALL_IDENTIFIERS
  end

  def update_all
    account_configs_to_delete = @account.account_authorization_configs.to_a.dup
    account_configs = {}
    params[:account_authorization_config].sort {|a,b| a[0] <=> b[0] }.each do |idx, data|
      id = data.delete :id
      disabled = data.delete :disabled
      next if disabled == '1'

      result = if id.to_i == 0
        account_config = @account.account_authorization_configs.build(data)
        account_config.save
      else
        account_config = @account.account_authorization_configs.find(id)
        account_configs_to_delete.delete(account_config)
        account_config.update_attributes(data)
      end

      if result
        account_configs[account_config.id] = account_config
      else
        return render :json => account_config.errors.to_json
      end
    end
    account_configs_to_delete.map(&:destroy)
    render :json => account_configs.to_json
  end

  def test_ldap_connection
    results = []
    @account.account_authorization_configs.each do |config|
      h = {
        :account_authorization_config_id => config.id,
        :ldap_connection_test => config.test_ldap_connection
      }
      results << h.merge({:errors => config.errors.map {|attr,msg| {attr => msg}}})
    end
    render :json => results.to_json
  end

  def test_ldap_bind
    results = []
    @account.account_authorization_configs.each do |config|
      h = {
        :account_authorization_config_id => config.id,
        :ldap_bind_test => config.test_ldap_bind
      }
      results << h.merge({:errors => config.errors.map {|attr,msg| {attr => msg}}})
    end
    render :json => results.to_json
  end

  def test_ldap_search
    results = []
    @account.account_authorization_configs.each do |config|
      res = config.test_ldap_search
      h = {
        :account_authorization_config_id => config.id,
        :ldap_search_test => res
      }
      results << h.merge({:errors => config.errors.map {|attr,msg| {attr => msg}}})
    end
    render :json => results.to_json
  end

  def test_ldap_login
    results = []
    unless @account.ldap_authentication?
      return render(
        :json => {:errors => {:account => t(:account_required, 'must be LDAP-authenticated')}},
        :status_code => 400
      )
    end
    unless params[:username]
      return render(
        :json => {:errors => {:login => t(:login_required, 'must be supplied')}},
        :status_code => 400
      )
    end
    unless params[:password]
      return render(
        :json => {:errors => {:password => t(:password_required, 'must be supplied')}},
        :status_code => 400
      )
    end
    @account.account_authorization_configs.each do |config|
      h = {
        :account_authorization_config_id => config.id,
        :ldap_login_test => config.test_ldap_login(params[:username], params[:password])
      }
      results << h.merge({:errors => config.errors.map {|attr,msg| {attr => msg}}})
    end
    render(
      :json => results.to_json,
      :status_code => 200
    )
  end

  def destroy_all
    @account.account_authorization_configs.each do |c|
      c.destroy
    end
    redirect_to :account_account_authorization_configs
  end
end
