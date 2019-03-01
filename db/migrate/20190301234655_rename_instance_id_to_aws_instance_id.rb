class RenameInstanceIdToAwsInstanceId < ActiveRecord::Migration[5.2]
  def change
    rename_column :instances, :instance_id, :aws_instance_id
  end
end
