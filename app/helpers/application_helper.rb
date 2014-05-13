module ApplicationHelper

  def site_name
    # Change the value below between the quotes.
    AppConfig.site_name
  end

  def site_url
    AppConfig.site_domain
  end

  def meta_author
    # Change the value below between the quotes.
    AppConfig.author
  end

  def meta_description
    # Change the value below between the quotes.
    AppConfig.meta_description
  end

  def meta_keywords
    # Change the value below between the quotes.
    AppConfig.meta_keywords
  end

  # Returns the full title on a per-page basis.
  # No need to change any of this we set title and site_name elsewhere.
  def full_title(page_title)
    if page_title.empty?
      site_name
    else
      "#{page_title} | #{site_name}"
    end
  end


  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success" # Green
      when "error"
        "alert-danger" # Red
      when "alert"
        "alert-warning" # Yellow
      when "notice"
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end


  def get_page_title(title, page_context, override_model_name, model_class)

    if override_model_name.blank?
      model_name = model_class.model_name.human
    else
      model_name = override_model_name
    end


    if page_context == :edit
      t(title, :default => [:'helpers.titles.edit', 'Edit %{model}'], :model => model_name).titleize

    elsif page_context == :new
      t(title, :default => [:'helpers.titles.new', 'New %{model}'], :model => model_name).titleize

    elsif page_context == :copy
      t(title, :default => [:'helpers.titles.copy', 'Copy %{model}'], :model => model_name).titleize

    elsif page_context == :show
      t(title, :default => model_name).titleize

    elsif page_context == :index
      t(title, :default => model_name).pluralize.titleize

    elsif page_context == :history
      t(title, :default => model_name).pluralize.titleize
    end
  end

end
