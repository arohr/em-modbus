# Copyright © 2016 Andy Rohr <andy.rohr@mindclue.ch>
# All rights reserved.

require 'rubygems'
require 'eventmachine'

module Modbus
  module Connection

    class TCPClient < Base


      # Initializes a new connection instance.
      #
      # @param handler The managing handler object.
      #
      def initialize(handler)
        super
        @transaction_ident    = 0
        @pending_transactions = []
      end


      # EM callback. Called when the TCP connection is sucessfully established.
      #
      def connection_completed
        @handler.connected self
      end


      # EM callback. Called when the TCP connection is closed.
      #
      def unbind
        @handler.disconnected
      end


      # Creates a successor transaction identfication in the range of 0..65535
      #
      # @return [Integer] The transaction identification
      #
      def next_transaction_ident
        @transaction_ident = @transaction_ident.succ.modulo 2**16
      end


      # Adds Transaction object to the list of tracked transactions
      #
      # @param transaction [Modbus::Transaction] The transaction object to add.
      #
      def track_transaction(transaction)
        puts "Too many pending pending transactions: #{@pending_transactions.size}" if @pending_transactions.size > 10
        @pending_transactions << transaction
      end


      # Looks for a matching transaction in the internal store by a transaction ident and returns it if found.
      #
      # @param transaction_ident [Integer] The transaction ident to match.
      # @return [Modbus::Transaction] The found Transaction object.
      #
      def pick_pending_transaction(transaction_ident)
        transaction = @pending_transactions.find { |r| r.transaction_ident == transaction_ident }
        @pending_transactions.delete transaction
        transaction
      end


      private


      def transaction_class
        Modbus::Transaction::Client
      end


    end # TCPClient

  end # Connection
end # Modbus
