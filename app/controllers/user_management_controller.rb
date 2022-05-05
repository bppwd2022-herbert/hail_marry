class UserManagementController < ApplicationController
  def assign_roles
    @users = User.all
    @roles = Role.all
  end
end
