require 'thor'
require 'thor/aws'

module Certsweeper
  class CLI < Thor
    include Thor::Aws

    class_option :verbose, type: :boolean, default: false, aliases: [:v]

    desc :list, "List expired and not assigned server certificates"
    def list
      client.list.each do |cert|
        m = cert.server_certificate_metadata
        puts [
          m.server_certificate_name,
          m.expiration
        ].join("\t")
      end
    end

    desc :remove, "Remove expired and not assignd server certificates"
    method_option :certificate_name,  type: :string
    method_option :all,               type: :boolean, default: false
    method_option :dry_run,           type: :boolean, default: false
    def remove
      if options[:all]
        result = client.remove_all
      else
        result = client.remove(options[:certificate_name])
      end

      unless result.empty?
        result.map {|r| puts "remove: #{r}"}
      end
      puts "No remove (dry-run)" if options[:dry_run]
    end

    private

    def client
      @client ||= Client.new options, aws_configuration
    end
  end
end
