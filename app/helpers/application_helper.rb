module ApplicationHelper
    def render_date(date)
        date.strftime("%l:%M%P %a %b #{date.day.ordinalize} %Y")
    end

    def render_time(time)
        sprintf("%.3f", time)
    end
end
