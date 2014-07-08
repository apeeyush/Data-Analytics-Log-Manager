module ApplicationHelper

  # Mapping from devise flast type to corresponding bootstrap class
  def bootstrap_class_for(flash_type)
    if flash_type == "success"
      return "alert-success"            # Green
    elsif flash_type == "error"
      return "alert-danger"             # Red
    elsif flash_type == "alert"
      return "alert-warning"            # Yellow
    elsif flash_type == "notice"
      return "alert-info"               # Blue
    else
      return flash_type.to_s
    end
  end

end
