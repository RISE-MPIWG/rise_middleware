class Hash
  def filter(*args)
    return nil if args.try(:empty?)

    if args.size == 1
      args[0] = args[0].to_s if args[0].is_a?(Symbol)
      select { |key| key.to_s.match(args.first) }
    else
      select { |key| args.include?(key) }
    end
  end
end
