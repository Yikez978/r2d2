class Device < ActiveRecord::Base
  belongs_to :list
  before_validation :default_values
  self.per_page = 10
  VALID_MAC_REGEX = /\A[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}:[\da-f]{2}\z/i
  validates :mac, presence: true,
                  format: { with: VALID_MAC_REGEX },
                  uniqueness: true
#  validates :list, presence: true
  def default_values
    self.list_id ||= List.find_by_name('Unassigned').id
  end
  
  def vendor
    trimmed_mac = self.mac.gsub(/[-:]/,'')
    begin
      vendor_name = Vendor.find_by(oui: trimmed_mac[0..5]).name
    rescue
      if !vendor_name
        vendor_name = 'UNKNOWN'
      end
    end
    vendor_name
  end
end
