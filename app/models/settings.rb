class Settings < ActiveRecord::Base
  def self.[](k)
    (first || default_settings)[k]
  end

  def self.default_settings
    Settings.create!
  end
end

def Settings; Settings.first; end
