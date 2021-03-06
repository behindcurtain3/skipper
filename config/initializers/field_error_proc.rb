ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe

  form_fields = [
    'textarea',
    'input',
    'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')

  elements.each do |e|
    if e.node_name.eql? 'label'
      html = %(#{e}).html_safe
    elsif form_fields.include? e.node_name
      if instance.error_message.kind_of?(Array)
        html = %(<div class="control-group has-error has-feedback">#{html_tag}
          <span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>
          <div class="alert alert-danger clear-bottom" role="alert">
            <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
            <span class="sr-only">Error:</span>
            #{instance.error_message.uniq.join(', ')}
          </div></div>
          ).html_safe
      else
        html = %(<div class="control-group has-error has-feedback">#{html_tag}<span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span>
          <div class="alert alert-danger clear-bottom" role="alert">
            <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
            <span class="sr-only">Error:</span>
            #{instance.error_message}
          </div></div>
          ).html_safe
      end
    end
  end
  html
end