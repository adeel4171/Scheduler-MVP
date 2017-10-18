class SessionsController < Devise::SessionsController  

   #  skip_before_action :verify_authenticity_token

   #  def respond_with(resource, opts = {})
   #  	respond_to do |format|
	  #       if current_user
	  #       	format.json { render json: resource.as_json().merge({ "role" => current_user.roles.first.name }) }
			# 			if current_user.has_role? :admin or current_user.has_role? :hr
			# 				format.html{ redirect_to hrm_users_path}
			# 			else
			# 				format.html{ redirect_to hrm_user_path(current_user)}
			# 			end

	  #       else
	  #       	format.json{head :no_content}
	  #       	format.html{}
	  #       end
	  #   end
  	# end
end 