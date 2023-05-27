class Base
  include Pundit::Authorization
  # def check_access(current_user)
  #   return true if (current_user.is_admin? || current_user.is_supplier?) 
  #   @response =
  #   {
  #     success: false, 
  #     message: "Access Denied"
  #   } 
  # end
end
