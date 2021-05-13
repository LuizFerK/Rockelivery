defmodule Rockelivery.Orders.ReportTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.Orders.Report

  describe "create/1" do
    setup do
      user = insert(:user)
      item = insert(:item)
      insert(:order, user_id: user.id, items: [item])
      insert(:order, user_id: user.id, items: [item])

      {:ok, user_id: user.id}
    end

    test "should generate the orders report", %{user_id: user_id} do
      filename = "report_test.csv"

      Report.create(filename)

      response = File.read!(filename)

      expected_response =
        "#{user_id},credit_card,food,Pepperoni Pizza,59.90,59.90\n" <>
          "#{user_id},credit_card,food,Pepperoni Pizza,59.90,59.90\n"

      assert expected_response == response
    end
  end
end
