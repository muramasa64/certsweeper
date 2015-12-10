require "aws-sdk"

module Certsweeper
  class Client
    attr_reader :logger

    def initialize(cli_options = {}, aws_configuration = {})
      @cli_options = cli_options
      @logger ||= Logger.new STDOUT

      aws_configuration[:logger] = Logger.new STDOUT if @cli_options.verbose
      @aws_configuration = aws_configuration

      @iam = Aws::IAM::Resource.new aws_configuration
    end

    def list
      Enumerator.new do |y|
        @iam.server_certificates.each do |cert|
          if expired?(cert) && (not use_by_elb?(cert))
            y << cert
          end
        end
      end
    end

    def remove_all
      removed_cert_name = []
      list.each do |cert|
        cert.delete unless @cli_options[:dry_run]
        removed_cert_name << cert.server_certificate_metadata.server_certificate_name
      end
      removed_cert_name
    end

    def remove(cert_name)
      list.each do |cert|
        if cert.server_certificate_metadata.server_certificate_name == cert_name
          cert.delete unless @cli_options[:dry_run]
          return [cert.server_certificate_metadata.server_certificate_name]
        end
      end
      []
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
      unless @elbs
        ec2 = Aws::EC2::Client.new @aws_configuration
        regions = ec2.describe_regions[:regions].map {|r| r[:region_name]}
        @elbs = []
        regions.each do |r|
          conf = @aws_configuration.dup
          conf[:region] = r
          elb_client = Aws::ElasticLoadBalancing::Client.new conf
          e = elb_client.describe_load_balancers
          @elbs += e.load_balancer_descriptions unless e.empty?
        end
      end
      @elbs
    end

    def expired?(cert)
      cert.server_certificate_metadata.expiration < now
    end

    def now
      @now ||= Time.now
    end
  end
end
