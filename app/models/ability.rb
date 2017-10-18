class Ability
  include CanCan::Ability


  def initialize(user)
    
    alias_action :read, :update, :destroy, to: :rud
    admin_users = User.with_role :admin
    developer_users = User.with_role :developer

    if user.roles.first.name == 'admin'
        can :create, User
        can :rud, User
        can :index, User
        can :create, Schedule
        can :rud, Schedule
        can :index, Schedule, user_id: user.id
        can :schedule_change_requests, Schedule
        can :approve_request, Schedule
        can :reject_request, Schedule

    elsif user.roles.first.name == 'developer'
         
        can :read, User, id: user.id
        can :index, User, id: user.id
        can :read, Schedule, user_id: user.id
        can :index, Schedule, user_id: user.id
        can :update, Schedule, user_id: user.id

        
        
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
