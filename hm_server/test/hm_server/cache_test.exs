defmodule HMServer.CacheTest do
  use HMServerWeb.ConnCase

  alias HMServer.Cache, as: Cache

  describe "get_or_store" do
    setup do
      {:ok, _ } = Cachex.clear(:api_cache)
      :ok
    end

    test "calls the store function when the value is not in the cache" do
      assert 15 == Cache.get_or_store("k1", fn -> 15 end)
    end

    test "does not call the store function when the value is in the cache" do
      assert 15 == Cache.get_or_store("k1", fn -> 15 end)
      assert 15 == Cache.get_or_store("k1", fn -> 100 end)
    end

    test "different keys can store different values" do
      assert 25 == Cache.get_or_store("k1", fn -> 25 end)
      assert 45 == Cache.get_or_store("k2", fn -> 45 end)
    end
  end
end