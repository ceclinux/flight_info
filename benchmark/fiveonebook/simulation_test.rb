require 'logger'
require 'date'
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

NUM_THREADS = 50
TIMES = 10
POSSIBILITY = 0.3
TIME_RANGE_START = Time.local(2018, 1, 1)
TIME_RANGE_END = Time.local(2018, 7, 1)

logger = Logger.new('fiveonebook.log')
threads = []
def time_rand(from = 0.0, to = Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end
0.upto(TIMES) do |t|
  NUM_THREADS.times do
    threads << Thread.new do
      params = {
        cabin_class: CABIN_CLASS.sample,
        direct_flight: DIRECT_FLIGHT.sample,
        adult_num: rand(ADULT_NUM),
        child_num: rand(CHILD_NUM),
        depart_airport: DEPART_AIRPORT.sample,
        arri_airport: ARRI_AIRPORT.sample,
        depart_time: time_rand(TIME_RANGE_START, TIME_RANGE_END).strftime('%F'),
        current_time: DateTime.now.strftime('%Q')
      }
      ret = FiveonebookFlight.search_flight(params)
      logger.debug(params.to_s)
      if ret['rsCode'] == '000000'
        logger.debug(ret.to_s)
      else
        logger.error(ret.to_s)
      end
    end
  end
  threads.each(&:join)
  logger.debug('=' * 70)
  logger.debug("#{t} test finished")
  logger.debug('=' * 70)
end
