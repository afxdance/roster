class AllowNullForThings < ActiveRecord::Migration[5.1]
  def change
    change_column_null :dancers, :name, true
    change_column_null :dancers, :email, true
    change_column_null :dancers, :phone, true
    change_column_null :dancers, :gender, true
    change_column_null :dancers, :year, true
    change_column_null :dancers, :dance_experience, true
    change_column_null :dancers, :exp_interest, true
    change_column_null :dancers, :tech_interest, true
    change_column_null :dancers, :camp_interest, true

    change_column_null :team_switch_requests, :name, true
    change_column_null :team_switch_requests, :email, true
    change_column_null :team_switch_requests, :phone, true
    change_column_null :team_switch_requests, :reason, true
    change_column_null :team_switch_requests, :approved_at, true
    change_column_null :team_switch_requests, :status, true

    change_column_null :teams, :level, true
    change_column_null :teams, :name, true
    change_column_null :teams, :practice_time, true
    change_column_null :teams, :locked, true
  end
end
