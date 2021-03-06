# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/backport/all/backport.rbi
#
# backport-1.2.0

module Backport
  def self.logger; end
  def self.machines; end
  def self.prepare_interval(period, &block); end
  def self.prepare_stdio_server(adapter: nil); end
  def self.prepare_tcp_server(host: nil, port: nil, adapter: nil); end
  def self.run(&block); end
  def self.stop; end
end
