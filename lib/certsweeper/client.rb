require "aws-sdk"

module Certsweeper
  class Client
    attr_reader :logger

    def initialize(cli_options = {}, aws_configuration = {})
      @cli_options = cli_options
      @logger ||= Logger.new STDOUT

      aws_configuration[:logger] = Logger.new STDOUT if @cli_options.verbose

      @iam = Aws::IAM::Resource.new aws_configuration
      @elb = Aws::ElasticLoadBalancing::Client.new aws_configuration
    end

    def list
      Enumerator.new do |y|
        @iam.server_certificates.each do |cert|
          t = cert.server_certificate_metadata.expiration
          if expired?(t) && (not use_by_elb?(cert))
            y << cert.server_certificate_metadata
          end
        end
      end
    end

    private

    def use_by_elb?(cert)
      elbs.each do |elb|
        elb.listener_descriptions.each do |l|
          if l.listener.ssl_certificate_id == cert.server_certificate_metadata.arn
            return true
          end
        end
      end
      false
    end

    def elbs
      @elbs ||= @elb.describe_load_balancers.load_balancer_descriptions
    end

    def expired?(cert_expiration)
      cert_expiration < now
    end

    def now
      @now ||= Time.now
    end
  end
end
