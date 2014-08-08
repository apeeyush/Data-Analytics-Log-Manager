class LogsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view, application_list)
    @view = view
    @application_list = application_list
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Log.where(application: @application_list).count,
      iTotalDisplayRecords: logs.total_count,
      aaData: data
    }
  end

private

  def data
    params[:timeZone].present? ? time_zone=params[:timeZone] : time_zone="Pacific Time (US & Canada)"
    logs.map do |log|
      [
        log.session,
        log.username,
        log.application,
        log.activity,
        log.event,
        (log.time.in_time_zone(time_zone).strftime("%Y-%m-%d, %I:%M:%S %p, %Z") if log.time.present?),
        log.parameters.to_s,
        log.extras.to_s,
        log.event_value
      ]
    end
  end

  def logs
    @logs ||= fetch_logs
  end

  def fetch_logs
    logs = Log.where(application: @application_list)
    logs = logs.order("#{sort_column} #{sort_direction}")
    if params[:applicationName].present?
      logs = logs.where(application: params[:applicationName])
    end
    if params[:activityName].present?
      logs = logs.where(activity: params[:activityName])
    end
    logs = logs.page(page).per(per_page)
    if params[:sSearch].present?
      logs = logs.where("application like :search or username like :search or activity like :search or event like :search", search: "%#{params[:sSearch]}%")
    end
    params[:timeZone].present? ? Time.zone=params[:timeZone] : Time.zone="Pacific Time (US & Canada)" 
    if params[:startPeriod].present? && params[:endPeriod].present?
      startPeriod = Time.zone.parse(params[:startPeriod]).utc
      endPeriod = Time.zone.parse(params[:endPeriod]).utc
      logs = logs.where("time >= :startPeriod AND time <= :endPeriod", {startPeriod: startPeriod, endPeriod: endPeriod})
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