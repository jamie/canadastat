require 'date'
class Date
  # From http://dateeaster.rubyforge.org/svn/trunk/lib/date_easter.rb
  def self.easter(year) 
    unless year.is_a? Numeric
      raise TypeError, "year must be Numeric" 
    end

    if year < 1583 
      raise ArgumentError, "Years before 1583 not supported"  
    elsif year > 4099
      raise ArgumentError, "Years after 4099 not supported"  
    end

    golden_number     = (year % 19) + 1
    century           = (year / 100) + 1
    julian_epact      = (11 * (golden_number -1)) % 30 
    solar_correction  = (3 * century) / 4
    lunar_correction  = ((8 * century) + 5) / 25
  
    gregorian_epact   = 
        (julian_epact - solar_correction + lunar_correction + 8) % 30
  
    days_fm_ve_to_pfm = (23 - gregorian_epact) % 30

    if gregorian_epact == 24 or gregorian_epact == 25 && golden_number > 11
      days_fm_ve_to_pfm -= 1 
    end

    vernal_equinox    = Date.new(year, 3, 21) 
    paschal_full_moon = vernal_equinox + days_fm_ve_to_pfm
  
    days_to_sunday    = 7 - paschal_full_moon.wday
  
    easter_sunday     = paschal_full_moon + days_to_sunday
  end
end


class Holiday
  def self.all(year, province=provinces)
    target_provinces = Array(province)

    @holidays.select{ |day|
      !(day.provinces & target_provinces).empty?
    }.map{ |holiday|
      holiday.new(year)
    }
  end
  
  def self.provinces(provs=nil)
    if provs
      @provs = provs
    else
      @provs || %w(BC AB SK MB ON QC NB NS PE NL YT NT NU)
    end
  end

  def self.inherited(klass)
    @holidays ||= []
    @holidays << klass
  end
  
  def initialize(year)
    @year = year
  end

  def self.name(n=nil)
    if n
      @name = n
    else
      @name
    end
  end
  def name
    self.class.name
  end

  def self.date(year=nil, &blk)
    if block_given?
      @date = blk
    else
      @year = year
      @date.call
    end
  end
  def date
    self.class.date(@year)
  end
  
  def self.relative_date(sequence, weekday, month)
    d = Date.new(@year, month, 1) + (7 * sequence)
    d += weekday - d.wday
    d
  end

  def to_s
    "%s %s" % [date.to_s, name]
  end
end

class NewYearsDay < Holiday
  name "New Year's Day"
  date { Date.new(@year, 1, 1) }
end

class IslanderDay < Holiday
  name "Islander Day"
  date { relative_date(3, 1, 2) } # 3rd Monday in Feb
  provinces %w(PE)
end

class FamilyDay < Holiday
  name "Family Day"
  date { relative_date(3, 1, 2) } # feb, 3rd, monday
  provinces %w(AB SK ON)
end

class LouisRielDay < Holiday
  name "Louis Riel Day"
  date { relative_date(3, 1, 2) } # 3rd Monday in Feb
  provinces %w(MB)
end

class GoodFriday < Holiday
  name "Good Friday"
  date { Date.easter(@year) - 2 }
  provinces(provinces - %w(QC))
end

class EasterMonday < Holiday
  name "Easter Monday"
  date { Date.easter(@year) + 1 }
  provinces %w(QC)
end

class VictoriaDay < Holiday
  name "Victoria Day"
  # Monday *preceeding* May 25.
  date { d = Date.new(@year, 5, 24); d += 1 - d.wday; d }
  provinces(provinces - %w(NB NS PE NL))
end

class NationalAboriginalDay < Holiday
  name "National Aboriginal Day"
  date { Date.new(@year, 6, 21) }
  provinces %w(NT)
end

class CanadaDay < Holiday
  name "Canada Day"
  date { Date.new(@year, 7, 1) }
end

class NunavutDay < Holiday
  name "Nunavut Day"
  date { Date.new(@year, 7, 9) }
  provinces %w(NU)
end

class CivicHoliday < Holiday
  name "Civic Holiday"
  date { relative_date(1, 1, 8) }
  provinces %w(BC SK MB NB NU)
end

class DiscoveryDay < Holiday
  name "Discovery Day"
  date { relative_date(3, 1, 8) }
  provinces %w(YT)
end

class LabourDay < Holiday
  name "Labour Day"
  date { relative_date(1, 1, 9) }
end

class Thanksgiving < Holiday
  name "Thanksgiving"
  date { relative_date(2, 1, 10) }
  provinces(provinces - %w(NB NS PE NL))
end

class RemembranceDay < Holiday
  name "Remembrance Day"
  date { Date.new(@year, 11, 11) }
  provinces(provinces - %w(MB ON QC NS NL))
end

class Christmas < Holiday
  name "Christmas Day"
  date { Date.new(@year, 12, 25) }
end

class BoxingDay < Holiday
  name "Boxing Day"
  date { Date.new(@year, 12, 26) }
  provinces %w(ON)
end


