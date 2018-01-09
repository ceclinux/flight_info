require 'logger'
require 'date'
require 'pp'
require '../../lib/flight_info/fiveonebook_flight.rb'

# 单程 往返 多程
ROUTE_TYPE = %w[OW RT MS].freeze
CABIN_CLASS = %w[ECONOMY PREMIUM_ECONOMY BUSINESS FIRST].freeze
ADULT_NUM = (0..6).freeze
CHILD_NUM = (0..3).freeze
# These two list comes from https://en.wikipedia.org/wiki/List_of_busiest_airports_by_passenger_traffic
DEPART_AIRPORT = %w[PEK PVG CAN SZX CTU].freeze
ARRI_AIRPORT = %w[ATL DXB LAX HND ORD LHR HKG CDG].freeze
DIRECT_FLIGHT = [true, false].freeze

TIMES = 1
POSSIBILITY = 0.3
TIME_RANGE_START = Time.local(2018, 1, 1)
TIME_RANGE_END = Time.local(2018, 7, 1)

logger = Logger.new('accurancy_test.log')
def time_rand(from = 0.0, to = Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end
File.open("pretty_print_accurancy.txt","w") do |f|
  0.upto(TIMES) do
    params = {
      cabin_class: CABIN_CLASS.sample,
      direct_flight: DIRECT_FLIGHT.sample,
      adult_num: rand(ADULT_NUM),
      child_num: rand(CHILD_NUM),
      depart_airport: ARRI_AIRPORT.sample,
      arri_airport: DEPART_AIRPORT.sample,
      depart_time: time_rand(TIME_RANGE_START, TIME_RANGE_END).strftime('%F'),
      current_time: DateTime.now.strftime('%Q')
    }
    ret = FiveonebookFlight.search_flight(cabin_class:'ECONOMY', direct_flight:false, adult_num:2, child_num:0, depart_airport:"SZX",arri_airport:"CDG", depart_time:"2018-01-16", current_time:DateTime.now.strftime('%Q'))
    logger.debug(params.to_s)
    pp ret
    PP.pp(params.to_s, f)
    if ret['rsCode'] == '000000'
      flight_list = ret['RSData']['avFlightList']
      translated = flight_list.map do |fl|
        {
          价格信息: fl['fareList'].map do |priceinfo|
            {
              成人单人结算价: priceinfo['adultPrice']&.[]('settlementPriceWithTax'),
              儿童单人结算价: priceinfo['childPrice']&.[]('settlementPriceWithTax'),
              免费寄包数量: priceinfo['freeBaggageAllowance']
            }
          end,
          航班信息: fl['odlist'].map do |odlist|
            {
              航空公司: odlist['airline'],
              出发: odlist['departureAirport'],
              抵达: odlist['arrivalAirport'],
              航班号: odlist['flightNo'],
              出发时间: odlist['departureTime'],
              抵达时间: odlist['arriveTime']
            }
          end
        }
      end
      logger.debug(translated)
      PP.pp(translated, f)
    else
      logger.debug(pp(ret.to_s))
      PP.pp(ret.to_s, f)
    end
  end

end
