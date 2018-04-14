class CreateInitialModels < ActiveRecord::Migration[5.1]
  def change
    create_table :dancers do |t|
      # Data columns
      t.string :name
      t.string :email
      t.string :phone
      t.string :gender
      t.string :year
      t.string :experience

      # Default colunmns
      t.timestamps
    end

    create_table :team_switch_requests do |t|
      # Data columns
      t.string :name
      t.string :email
      t.string :phone
      t.text :reason
      t.datetime :approved_at
      t.string :status

      # Relations
      t.belongs_to :old_team, index: true
      t.belongs_to :new_team, index: true
      t.belongs_to :dancer, index: true

      # Default colunmns
      t.timestamps
    end

    create_table :teams do |t|
      # Data columns
      t.string :name
      t.string :type_of #'type' is a restricted word in ruby
      t.string :practice_time
      t.boolean :locked

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

    create_join_table :team_switch_requests, :teams, table_name: :team_switch_requests_available_teams do |t|
      # Join table columns
      t.index [:team_switch_request_id, :team_id], name: :index_team_switch_requests_available_teams_on_request_and_team
      t.index [:team_id, :team_switch_request_id], name: :index_team_switch_requests_available_teams_on_team_and_request

      # Default colunmns
      t.timestamps
    end
  end
end
