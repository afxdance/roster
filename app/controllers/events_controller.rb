class EventsController < InheritedResources::Base

  private

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time)
    end
end

