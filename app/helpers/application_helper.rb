module ApplicationHelper
  def new_button(url, classes: nil)
    link_to t(".new"), url, class: classes.presence || "rounded-md px-3.5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white block font-medium"
  end

  def save_button
    button_tag t("actions.save"), class: "w-full sm:w-auto rounded-md px-3.5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white inline-block font-medium cursor-pointer"
  end

  def back_button(url)
    link_to t("actions.back"), url, class: "w-full sm:w-auto text-center mt-2 sm:mt-0 sm:ml-2 rounded-md px-3.5 py-2.5 bg-gray-100 hover:bg-gray-50 inline-block font-medium"
  end

  def show_button(record, classes: nil)
    link_to t("actions.show"), record, class: classes.presence || "w-full sm:w-auto text-center rounded-md px-3.5 py-2.5 bg-gray-100 hover:bg-gray-50 inline-block font-medium"
  end

  def show_form_button(record)
    link_to t("actions.show"), record, class: "w-full sm:w-auto text-center mt-2 sm:mt-0 sm:ml-2 rounded-md px-3.5 py-2.5 bg-gray-100 hover:bg-gray-50 inline-block font-medium"
  end

  def edit_button(url, classes: nil)
    link_to t("actions.edit"), url, class: classes.presence || "w-full sm:w-auto text-center rounded-md px-3.5 py-2.5 bg-gray-100 hover:bg-gray-50 inline-block font-medium"
  end

  def destroy_button(record, classes: nil)
    button_to t("actions.destroy"), record, method: :delete, class: classes.presence || "w-full sm:w-auto rounded-md px-3.5 py-2.5 text-white bg-red-600 hover:bg-red-500 font-medium cursor-pointer", data: { turbo_confirm: t("common.confirmation") }
  end

  def destroy_form_button(record)
    button_to t("actions.destroy"), record, method: :delete, form_class: "sm:inline-block mt-2 sm:mt-0 sm:ml-2", class: "w-full sm:w-auto rounded-md px-3.5 py-2.5 text-white bg-red-600 hover:bg-red-500 font-medium cursor-pointer", data: { turbo_confirm: t("common.confirmation") }
  end

  # Sacado de https://github.com/rwz/nestive/blob/master/lib/nestive/layout_helper.rb
  def extends(layout, &block)
    # Asegurarse que es string
    layout = layout.to_s

    # Agregar prefijo de layouts si no está presente
    layout = "layouts/#{layout}" unless layout.include?('/')

    # Reemplazar el contenido del layout con el bloque dado
    @view_flow.get(:layout).replace capture(&block)

    render template: layout
  end
end