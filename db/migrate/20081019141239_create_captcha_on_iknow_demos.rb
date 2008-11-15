class CreateCaptchaOnIknowDemos < ActiveRecord::Migration
  def self.up
    create_table :captcha_on_iknow_demos do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :captcha_on_iknow_demos
  end
end
