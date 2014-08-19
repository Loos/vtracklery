json.array!(@surveys) do |survey|
  json.extract! survey, *Survey::API_ATTRIBUTES
  json.url api_v1_survey_url(survey, format: :json)
end

API_ATTRIBUTES = [ :assist_host, :host_program, :greet_open, :frequency, :tues_vol, :tues_open, :thurs_youth, :thurs_open, :fri_vol, :sat_sale, :sat_open, :can_name_bike, :can_fix_flat, :can_replace_tire, :can_replace_seat, :can_replace_cables, :can_adjust_brakes, :can_adjust_derailleurs, :can_replace_brakes, :can_replace_shifters, :can_remove_pedals, :replace_crank, :can_adjust_bearing, :can_overhaul_hubs, :can_overhaul_bracket, :can_overhaul_headset, :can_true_wheels, :can_replace_fork, :assist_youth, :assist_tuneup, :assist_overhaul, :pickup_donations, :taken_tuneup, :taken_overhaul, :drive_stick, :have_vehicle, :represent_recyclery, :sell_ebay, :organize_drive, :organize_events, :skill_graphic_design, :skill_drawing, :skill_photography, :skill_videography, :skill_programming, :skill_grants, :skill_newsletter, :skill_carpentry, :skill_coordination, :skill_fundraising, :comment, :created_at, :updated_at ]

