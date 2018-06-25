class CreateInitialModels < ActiveRecord::Migration[5.1]
  def change
    create_table :dancers do |t|
      # Data columns
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :gender, null: false
      t.string :year, null: false
      t.string :dance_experience, null: false
      t.string :exp_interest, null: false
      t.string :tech_interest, null: false
      t.string :camp_interest, null: false

      # Default colunmns
      t.timestamps
    end

    create_table :team_switch_requests do |t|
      # Data columns
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.text :reason, null: false
      t.datetime :approved_at, null: false
      t.string :status, null: false

      # Relations
      t.belongs_to :old_team, index: true
      t.belongs_to :new_team, index: true
      t.belongs_to :dancer, index: true

      # Default colunmns
      t.timestamps
    end

    create_table :teams do |t|
      # Data columns
      t.string :level, null: false # "type" is a reserved word in ruby
      t.string :name, null: false
      t.string :practice_time, null: false
      t.boolean :locked, null: false
      t.integer :maximum_picks

      # Relations
      t.belongs_to :user, index: true

      # Default colunmns
      t.timestamps
    end

    create_join_table :dancers, :teams do |t|
      # Join table columns
      t.index [:dancer_id, :team_id]
      t.index [:team_id, :dancer_id]

      # Default colunmns
      t.timestamps
    end

    create_join_table :users, :teams do |t|
      # Join table of users to teams
      t.index [:user_id, :team_id]
      t.index [:team_id, :user_id]

      # Default
      t.timestamps
    end

    create_join_table :team_switch_requests, :teams, table_name: :team_switch_requests_available_teams do |t|
      # Join table columns
      t.index [:team_switch_request_id, :team_id], name: :index_team_switch_requests_available_teams_on_request_and_team
      t.index [:team_id, :team_switch_request_id], name: :index_team_switch_requests_available_teams_on_team_and_request

      # Default colunmns
      t.timestamps
    end
  end
end
