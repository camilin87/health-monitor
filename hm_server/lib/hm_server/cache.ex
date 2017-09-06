defmodule HMServer.Cache do
  def get_or_store(key, store_func, ttl \\ :short) do
    case Cachex.get(:api_cache, key) do
      {:ok, value} -> value
      _ ->
        value = store_func.()
        options = cache_options(ttl)
        Cachex.set!(:api_cache, key, value, options)
        value
    end
  end

  defp cache_options(ttl) do
    seconds = ttl_to_seconds(ttl)
    [ ttl: :timer.seconds(seconds) ]
  end

  defp ttl_to_seconds(ttl) do
    case ttl do
      :short -> 5
      _ -> 60
    end
  end
end