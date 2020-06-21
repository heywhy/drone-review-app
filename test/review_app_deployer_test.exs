defmodule ReviewAppDeployerTest do
  use ExUnit.Case
  doctest ReviewAppDeployer

  test "greets the world" do
    assert ReviewAppDeployer.hello() == :world
  end
end
