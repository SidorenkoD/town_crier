class AddQue < ActiveRecord::Migration[5.1]
  def up
    Que.migrate! version: 3
  end

  def down
    Que.migrate! version: 0
  end
end
