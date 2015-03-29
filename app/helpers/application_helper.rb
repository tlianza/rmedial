# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  #Provide a string representation of time
  def time_formatter(seconds_float)
    return '' if seconds_float.blank?
    seconds = (seconds_float % 60).to_i
    minutes = seconds_float >= 60 ? (seconds_float/60) % 60 : 0
    hours = minutes >= 60 ? (minutes/60) % 60 : 0
    outstring = hours > 0 ? sprintf("%.2i", hours) +':' : ''
    outstring << sprintf("%.2i", minutes)+':'+sprintf("%.2i", seconds)
    return outstring
  end
end
