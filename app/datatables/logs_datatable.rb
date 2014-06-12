class LogsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Log.count,
      iTotalDisplayRecords: logs.total_count,
      aaData: data
    }
  end

private

  def data
    time_zone = "Pacific Time (US & Canada)"
    logs.map do |log|
      [
        log.session,
        log.username,
        log.application,
        log.activity,
        log.event,
        log.time.in_time_zone(time_zone).strftime("%Y-%m-%d, %I:%M:%S %p, %Z"),
        log.parameters,
        log.extras
      ]
    end
  end

  def logs
    @logs ||= fetch_logs
  end

  def fetch_logs
    logs = Log.order("#{sort_column} #{sort_direction}")
    logs = logs.page(page).per(per_page)
    if params[:sSearch].present?
      logs = logs.where("application like :search or username like :search", search: "%#{params[:sSearch]}%")
    end
    logs
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[session username application activity event time ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end