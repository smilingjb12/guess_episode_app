class AddLabelToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :label, :string
  end
end
