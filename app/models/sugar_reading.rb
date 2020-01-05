class SugarReading
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :reading_date, type: Date
  field :glucose_level, type: Integer
  field :glucose_unit, type: String, default: "mg/dL"
  
  validates :glucose_level, :numericality => { :greater_than_or_equal_to => 0 }
  validates_presence_of :glucose_level, message: "Please provide the glucose level"
  
  #validate :no_future_reading_date
  validate :reading_date_validations
  belongs_to :user
  
  def no_future_reading_date
    if reading_date.present? && reading_date > Date.today
      errors.add(:reading_date, "Reading date cannot be a future date!!")
      false
    end
  end
    
  
  def reading_date_validations
    ##If no date specified retur error
    if reading_date.present?
      #If future date specified return error
      if reading_date > Date.today
        errors.add(:reading_date, "Reading date cannot be a future date!!")
        false
      else
        #Checo record count and if >= 4, return error
        existing_records = SugarReading.where(reading_date: reading_date).and(user_id: self.user_id).count
        if existing_records >= 4 && self.reading_date_changed?
          #p "Inside limit check",existing_records , self.reading_date_changed?
          errors.add(:reading_date, "Limit reached!!. You can only create 4 records per day.")
          false
        end
      end
    else
      errors.add(:reading_date, "Reading Date cannot be empty!")
      false
    end
  end
    
  
  
  
end
