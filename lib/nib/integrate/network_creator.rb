module Nib
  module Integrate
    # NetworkCreator creates the nib-integrate-network
    class NetworkCreator
      class << self
        def call
          create_network unless network_exists?
        end

        private

        def create_network
          system 'docker network create nib-integrate-network'
        end

        def network_exists?
          `docker network ls` =~ /nib-integrate-network/
        end
      end
    end
  end
end
