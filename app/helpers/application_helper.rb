module ApplicationHelper

  def dropzone_controller_div
    data = {
      controller: "dropzone",
      'dropzone-max-file-size'=>"8",
      'dropzone-max-files' => "10",
      'dropzone-accepted-files' => 'image/jpeg,image/jpg,image/png,image/gif',
      'dropzone-dict-file-too-big' => "Váš obrázok ma veľkosť {{filesize}} ale povolené sú len obrázky do veľkosti {{maxFilesize}} MB",
      'dropzone-dict-invalid-file-type' => "Nesprávny formát súboru. Iba obrazky .jpg, .png alebo .gif su povolene",
    }

    content_tag :div, class: 'dropzone dropzone-default dz-clickable', data: data do
      yield
    end
  end
end