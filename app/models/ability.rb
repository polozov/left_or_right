class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all
    else
      can :read, Category

      if user.has_role? :editor
        can :manage, Category
        can :manage, Element
      end

      if user.has_role? :user
        can :vote, :all
      end
    end
  end
end
