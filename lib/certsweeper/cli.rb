require 'thor'
require 'thor/aws'

module Certsweeper
  class CLI < Thor
    include Thor::Aws

    class_option :verbose, type: :boolean, default: false, aliases: [:v]

    desc :list, "List expired and not assigned server certificates"
    def list
      client.list.each do |cert|
        puts [
          cert.server_certificate_name,
          cert.expiration
        ].join("\t")
      end
    end

    private

    def client
      @client ||= Client.new options, aws_configuration
    end
  end
end
