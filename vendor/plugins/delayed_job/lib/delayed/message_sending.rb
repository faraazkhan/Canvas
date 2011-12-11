module Delayed
  module MessageSending
    def send_later(method, *args)
      Delayed::Job.enqueue Delayed::PerformableMethod.new(self, method.to_sym, args)
    end

    def send_later_enqueue_args(method, enqueue_args = {}, *args)
      # support procs/methods as enqueue arguments
      duped = false
      enqueue_args.each do |k,v|
        if v.respond_to?(:call)
          enqueue_args = enqueue_args.dup unless duped
          duped = true
          enqueue_args[k] = v.call(self)
        end
      end

      Delayed::Job.enqueue(Delayed::PerformableMethod.new(self, method.to_sym, args), enqueue_args)
    end

    def send_later_with_queue(method, queue, *args)
      send_later_enqueue_args(method, { :queue => queue }, *args)
    end

    def send_at(time, method, *args)
      send_later_enqueue_args(method,
                          { :run_at => time }, *args)
    end

    def send_at_with_queue(time, method, queue, *args)
      send_later_enqueue_args(method,
                          { :run_at => time, :queue => queue },
                          *args)
    end

    def send_later_unless_in_job(method, *args)
      if Delayed::Job.in_delayed_job?
        send(method, *args)
      else
        send_later(method, *args)
      end
      nil # can't rely on the type of return value, so return nothing
    end

    module ClassMethods
      def handle_asynchronously(method, enqueue_args = {})
        aliased_method, punctuation = method.to_s.sub(/([?!=])$/, ''), $1
        with_method, without_method = "#{aliased_method}_with_send_later#{punctuation}", "#{aliased_method}_without_send_later#{punctuation}"
        define_method(with_method) do |*args|
          send_later_enqueue_args(without_method, enqueue_args, *args)
        end
        alias_method_chain method, :send_later
      end

      def handle_asynchronously_with_queue(method, queue)
        handle_asynchronously(method, :queue => queue)
      end
    end
  end
end
