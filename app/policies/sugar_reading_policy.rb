class SugarReadingPolicy < ApplicationPolicy
  
  attr_reader :user, :reading_obj
  
  def initialize(user, reading_obj)
    @user = user
    @reading_obj = reading_obj
  end
  
  def update?
    #Only currently logged in user can update
    @reading_obj.user == @user
  end
  
  def show?
    @reading_obj.user == @user
  end
  
  def destroy?
   @reading_obj.user == @user
  end
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
