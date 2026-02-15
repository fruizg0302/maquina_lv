defmodule MaquinaLv.DropdownTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Dropdown

  describe "dropdown/1" do
    test "renders dropdown container" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown>
          <a href="/profile">Profile</a>
        </.dropdown>
        """)

      assert html =~ ~s(data-menu-button-part="content")
      assert html =~ ~s(role="menu")
      assert html =~ ~s(aria-orientation="vertical")
      assert html =~ "Profile"
    end

    test "starts hidden" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown>
          <span>item</span>
        </.dropdown>
        """)

      assert html =~ "hidden"
    end

    test "passes class attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown class="my-dropdown">
          <span>item</span>
        </.dropdown>
        """)

      assert html =~ "my-dropdown"
    end
  end
end
