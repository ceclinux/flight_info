require_relative 'abstract_flight'
require_relative 'auth'

class FiveonebookFlight
  extend AbstractFlight
  include HTTParty
  include Auth

  def self.build_query(args)
    cabin_class, direct_flight, adult_num, child_num, depart_airport, arri_airport, depart_time, current_time, return_airport, home_airport, back_time = args.values_at(:cabin_class, :direct_flight, :adult_num, :child_num, :depart_airport, :arri_airport, :depart_time, :current_time, :return_airport, :home_airport, :back_time)
    {
      agencyCode: Auth.username,
      rsIsGzip: true,
      timeStamp: current_time,
      RQData: {
        cabinClass: cabin_class,
        directFlight: direct_flight,
        routeType: 'RT',
        resourceChannel: 1,
        passengerNumberVo: [{
          passengerType: 'ADT',
          passengerNumber: adult_num
        }, {
          passengerType: 'CHD',
          passengerNumber: child_num
        }],
        segmentList: [{
          departureAirport: depart_airport,
          arrivalAirport: arri_airport,
          departureTime: depart_time
        },
                      {
                        departureAirport: return_airport,
                        arrivalAirport: home_airport,
                        departureTime: back_time
                      }]
      }
    }
  end

  def self.body_content(args)
    {
      'Content-Type' => 'application/json',
      'USERNAME' => Auth.username,
      'SIGN' => Digest::MD5.hexdigest(build_query(args).to_json + Auth.password),
      'Accept-Charset' => 'utf-8',
      'contentType' => 'utf-8'
    }
  end

  def self.search_flight(args)
    query '/searchFlight', args
  end

  base_uri "interws.51book.com/#{Auth.username}/search/"
end
