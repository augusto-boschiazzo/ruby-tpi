module SalesHelper
  def sale_status(sale)
    if sale.cancelled_at.present?
      "Cancelada el #{I18n.l(sale.cancelled_at, format: :short)}"
    else
      "Activa"
    end
  end
end
