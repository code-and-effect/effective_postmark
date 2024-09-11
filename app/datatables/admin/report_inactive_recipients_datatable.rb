# Postmark: Inactive Recipients

module Admin
  class ReportInactiveRecipientsDatatable < Effective::Datatable
    datatable do
      col :id, visible: false

      col(:to_s, label: 'User', sql_column: true, partial: 'admin/users/col')
      .search do |collection, term|
        collection.where(id: effective_resource.search_any(term))
      end.sort do |collection, direction|
        collection.order(first_name: direction)
      end

      col :email, visible: false
      col :first_name, visible: false
      col :last_name, visible: false

      col :postmark_error
      col :postmark_error_at

      actions_col(actions: []) do |user|
        dropdown_link_to('Reactivate', effective_postmark.postmark_reactivate_admin_postmark_path(user), remote: true, method: :post)
        dropdown_link_to('Edit', "/admin/users/#{user.to_param}/edit")
      end
    end

    collection do
      current_user.class.postmark_inactive_recipients
    end
  end
end
