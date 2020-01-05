class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  
  
  field :name, type: String
  field :date_of_birth, type: Date
  field :type, type: String, default: "Patient"
  field :contact_number, type: String
  field :address, type: String
  
  
  validates_presence_of :name, message: "User Name cannot be blank!!"
  validates_presence_of :date_of_birth, message: "Please enter your Date of Birth"
  validate :no_future_dob 
  validates_presence_of :type, message: "Please mention type of user"
  validates_inclusion_of :type, in: :available_user_types, message:"Invalid Type chosen"
  
  has_many :sugar_readings
  
  def no_future_dob
    if date_of_birth.present? && date_of_birth > Date.today
      errors.add(:date_of_birth, "DOB cannot be a Future date!!")
      false
    end
  end 
  
  def available_user_types
    ["Patient", "Doctor"]
  end
  
  def get_reports(report_date, report_type)
    eligible_readings = {"report_date" => report_date, "report_type" => report_type}
    case report_type
    when "Daily"
      #get_daily_reports(report_date)
      reports = SugarReading.collection.aggregate(
      {
        "$match" => { 
          :reading_date => Date.parse(report_date),
          :"user_id" => self.id
        }
      },
      { 
        "$group" => {
          :_id => "$user_id", 
          :max_reading => { "$max" => "$glucose_level" },
          :min_reading => { "$min" => "$glucose_level" },
          :avg_reading => { "$avg" => "$glucose_level" }
        }
      }
      )
    when "Month-Date"
      #get_month_to_date_reports(report_date)
      calendar_start_date = Date.today.beginning_of_month
      reports = SugarReading.collection.aggregate(
      {
        "$match" => { 
          :reading_date => { "$gte" => calendar_start_date, "$lte"=> report_date },
          :"user_id" => self.id
        }
      },
      { 
        "$group" => {
          :_id => "$user_id",
          :max_reading => { "$max" => "$glucose_level" },
          :min_reading => { "$min" => "$glucose_level" },
          :avg_reading => { "$avg" => "$glucose_level" }
        }
      }
      )
    when "Monthly"
      #get_monthly_reports(report_date)
      calendar_start_date = Date.parse(report_date).prev_month.beginning_of_month
      calendar_end_date = Date.today.prev_month.end_of_month
      reports = SugarReading.collection.aggregate(
      {
        "$match" => { 
          :reading_date => { "$gte" => calendar_start_date, "$lte"=> calendar_end_date },
          :"user_id" => self.id
        }
      },
      { 
        "$group" => {
          :_id => "$user_id",
          :max_reading => { "$max" => "$glucose_level" },
          :min_reading => { "$min" => "$glucose_level" },
          :avg_reading => { "$avg" => "$glucose_level" }
        }
      }
      )
    end
    p "Records: #{reports}"
    if reports.count > 0
      eligible_readings.merge(reports.first)
    else
      eligible_readings
    end
  end

  # #Get daily reports
#   def get_daily_reports(report_date)
#     eligible_readings = {"report_date" => report_date }
#
#     reports = SugarReading.collection.aggregate(
#     {
#       "$match" => {
#         :reading_date => Date.parse(report_date),
#         :"user_id" => self.id
#       }
#     },
#     {
#       "$group" => {
#         :_id => "$user_id",
#         :max_reading => { "$max" => "$glucose_level" },
#         :min_reading => { "$min" => "$glucose_level" },
#         :avg_reading => { "$avg" => "$glucose_level" }
#       }
#     }
#     )
#
#     if reports.count > 0
#       eligible_readings.merge(reports.first)
#     else
#       eligible_readings
#     end
#
#   end
#
#   def get_month_to_date_reports(report_date)
#     eligible_readings = {"report_date" => report_date}
#     calendar_start_date = Date.today.beginning_of_month
#     reports = SugarReading.collection.aggregate(
#     {
#       "$match" => {
#         :reading_date => { "$gte" => calendar_start_date, "$lte"=> report_date },
#         :"user_id" => self.id
#       }
#     },
#     {
#       "$group" => {
#         :_id => "$user_id",
#         :max_reading => { "$max" => "$glucose_level" },
#         :min_reading => { "$min" => "$glucose_level" },
#         :avg_reading => { "$avg" => "$glucose_level" }
#       }
#     }
#     )
#
#     if reports.count > 0
#       eligible_readings.merge(reports.first)
#     else
#       eligible_readings
#     end
#
#   end
#
#   def get_monthly_reports(report_date=Date.today)
#     #records = SugarReading.where(reading_date: report_date).and(user_id: self.id)
#     eligible_readings = {"report_date" => report_date}
#     calendar_start_date = report_date.prev_month.beginning_of_month
#     calendar_end_date = Date.today.prev_month.end_of_month
#     reports = SugarReading.collection.aggregate(
#     {
#       "$match" => {
#         :reading_date => { "$gte" => calendar_start_date, "$lte"=> calendar_end_date },
#         :"user_id" => self.id
#       }
#     },
#     {
#       "$group" => {
#         :_id => "$user_id",
#         :max_reading => { "$max" => "$glucose_level" },
#         :min_reading => { "$min" => "$glucose_level" },
#         :avg_reading => { "$avg" => "$glucose_level" }
#       }
#     }
#     )
#
#     if reports.count > 0
#       eligible_readings.merge(reports.first)
#     else
#       eligible_readings
#     end
#
#   end
	
end
