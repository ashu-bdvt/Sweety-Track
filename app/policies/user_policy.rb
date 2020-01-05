class UserPolicy < ApplicationPolicy
  attr_reader :user, :userobj
  
  def initialize(user, userobj)
    @user = user
    @userobj = userobj

  end
  
  def update?
    #Only currently logged in user can update
    @user.eql?(@userobj)
  end
  
  def show?
    #Only currently logged in user can get details
    @user.eql?(@userobj)
  end
  
  def destroy?
    #Only currently logged in user can destroy
    @user.eql?(@userobj)
  end
  
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
