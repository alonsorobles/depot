module StoreHelper
  def hidden_div_if(condition, attributes = {}, &block)
    hidden_element_if("div", condition, attributes, &block)
  end
  
  def hidden_element_if(element, condition, attributes, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag(element, attributes, &block)
  end
  
  def start_hidden_element_if(element, condition, attributes)
    if condition
      attributes["style"] = "display: none"
    end
    attrs = tag_options attributes.stringify_keys
    "<#{element} #{attrs}>"
  end
end
