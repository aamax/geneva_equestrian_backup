module ApplicationHelper
  def title
    base_title = "Basic Site"
    if @title.nil?
      base_title
    else 
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("header1.jpg", :alt => "LOGO",
                             :class => "headerbanner")  
  end
    
end
