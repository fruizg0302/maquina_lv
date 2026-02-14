defmodule MaquinaLv.CardTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Card

  # ── card/1 ──────────────────────────────────────────────────────────

  describe "card/1" do
    test "renders a div with data-component='card'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>content</.card>
        """)

      assert html =~ ~s(data-component="card")
      assert html =~ "<div"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card class="my-class">content</.card>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "renders empty class attribute when class is nil" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>content</.card>
        """)

      # Phoenix renders class="" for nil class values; this is harmless
      assert html =~ ~s(class="")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card id="my-card">content</.card>
        """)

      assert html =~ ~s(id="my-card")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <p>Card content</p>
        </.card>
        """)

      assert html =~ "<p>Card content</p>"
      assert html =~ ~s(data-component="card")
    end
  end

  # ── card_header/1 ───────────────────────────────────────────────────

  describe "card_header/1" do
    test "renders a div with data-card-part='header'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_header>content</.card_header>
        """)

      assert html =~ ~s(data-card-part="header")
      assert html =~ "<div"
    end

    test "does not emit data-layout when layout is default (:column)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_header>content</.card_header>
        """)

      refute html =~ "data-layout"
    end

    test "does not emit data-layout when layout is explicitly :column" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_header layout={:column}>content</.card_header>
        """)

      refute html =~ "data-layout"
    end

    test "emits data-layout='row' when layout is :row" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_header layout={:row}>content</.card_header>
        """)

      assert html =~ ~s(data-layout="row")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_header class="extra">content</.card_header>
        """)

      assert html =~ ~s(class="extra")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_header id="hdr">content</.card_header>
        """)

      assert html =~ ~s(id="hdr")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_header>
          <span>Header</span>
        </.card_header>
        """)

      assert html =~ "<span>Header</span>"
    end
  end

  # ── card_title/1 ────────────────────────────────────────────────────

  describe "card_title/1" do
    test "renders an h3 with data-card-part='title'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_title text="Title" />
        """)

      assert html =~ ~s(data-card-part="title")
      assert html =~ "<h3"
    end

    test "renders text attribute as content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_title text="Hello" />
        """)

      assert html =~ "Hello"
    end

    test "inner block takes priority over text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_title text="Ignored">
          <span>Block wins</span>
        </.card_title>
        """)

      assert html =~ "Block wins"
      refute html =~ "Ignored"
    end

    test "does not emit data-size when size is default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_title text="T" />
        """)

      refute html =~ "data-size"
    end

    test "does not emit data-size when size is explicitly :default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_title text="T" size={:default} />
        """)

      refute html =~ "data-size"
    end

    test "emits data-size='sm' when size is :sm" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_title text="T" size={:sm} />
        """)

      assert html =~ ~s(data-size="sm")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_title text="T" class="bold" />
        """)

      assert html =~ ~s(class="bold")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_title text="T" id="ttl" />
        """)

      assert html =~ ~s(id="ttl")
    end
  end

  # ── card_description/1 ─────────────────────────────────────────────

  describe "card_description/1" do
    test "renders a p with data-card-part='description'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_description text="Desc" />
        """)

      assert html =~ ~s(data-card-part="description")
      assert html =~ "<p"
    end

    test "renders text attribute as content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_description text="Some desc" />
        """)

      assert html =~ "Some desc"
    end

    test "inner block takes priority over text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_description text="Ignored">
          <em>Block wins</em>
        </.card_description>
        """)

      assert html =~ "Block wins"
      refute html =~ "Ignored"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_description class="muted" />
        """)

      assert html =~ ~s(class="muted")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_description id="dsc" />
        """)

      assert html =~ ~s(id="dsc")
    end
  end

  # ── card_content/1 ──────────────────────────────────────────────────

  describe "card_content/1" do
    test "renders a div with data-card-part='content'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_content>content</.card_content>
        """)

      assert html =~ ~s(data-card-part="content")
      assert html =~ "<div"
    end

    test "does not emit data-spacing when spacing is default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_content>content</.card_content>
        """)

      refute html =~ "data-spacing"
    end

    test "does not emit data-spacing when spacing is explicitly :default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_content spacing={:default}>content</.card_content>
        """)

      refute html =~ "data-spacing"
    end

    test "emits data-spacing='full' when spacing is :full" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_content spacing={:full}>content</.card_content>
        """)

      assert html =~ ~s(data-spacing="full")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_content class="p-4">content</.card_content>
        """)

      assert html =~ ~s(class="p-4")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_content id="cnt">content</.card_content>
        """)

      assert html =~ ~s(id="cnt")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_content>
          <p>Body</p>
        </.card_content>
        """)

      assert html =~ "<p>Body</p>"
    end
  end

  # ── card_footer/1 ───────────────────────────────────────────────────

  describe "card_footer/1" do
    test "renders a div with data-card-part='footer'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer>content</.card_footer>
        """)

      assert html =~ ~s(data-card-part="footer")
      assert html =~ "<div"
    end

    test "does not emit data-align when align is default (:start)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer>content</.card_footer>
        """)

      refute html =~ "data-align"
    end

    test "does not emit data-align when align is explicitly :start" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer align={:start}>content</.card_footer>
        """)

      refute html =~ "data-align"
    end

    test "emits data-align='between' when align is :between" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer align={:between}>content</.card_footer>
        """)

      assert html =~ ~s(data-align="between")
    end

    test "emits data-align='end' when align is :end" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer align={:end}>content</.card_footer>
        """)

      assert html =~ ~s(data-align="end")
    end

    test "emits data-align='center' when align is :center" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer align={:center}>content</.card_footer>
        """)

      assert html =~ ~s(data-align="center")
    end

    test "does not emit data-spacing when spacing is default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer>content</.card_footer>
        """)

      refute html =~ "data-spacing"
    end

    test "emits data-spacing='full' when spacing is :full" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer spacing={:full}>content</.card_footer>
        """)

      assert html =~ ~s(data-spacing="full")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer class="mt-2">content</.card_footer>
        """)

      assert html =~ ~s(class="mt-2")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer id="ftr">content</.card_footer>
        """)

      assert html =~ ~s(id="ftr")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_footer>
          <button>Save</button>
        </.card_footer>
        """)

      assert html =~ "<button>Save</button>"
    end
  end

  # ── card_action/1 ───────────────────────────────────────────────────

  describe "card_action/1" do
    test "renders a div with data-card-part='action'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_action>content</.card_action>
        """)

      assert html =~ ~s(data-card-part="action")
      assert html =~ "<div"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_action class="gap-4">content</.card_action>
        """)

      assert html =~ ~s(class="gap-4")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_action id="act">content</.card_action>
        """)

      assert html =~ ~s(id="act")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card_action>
          <button>Action</button>
        </.card_action>
        """)

      assert html =~ "<button>Action</button>"
    end
  end

  # ── Full composition ────────────────────────────────────────────────

  describe "full card composition" do
    test "all sub-components compose together correctly" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.card>
          <.card_header layout={:row}>
            <div>
              <.card_title text="Dashboard" />
              <.card_description text="Overview of your account" />
            </div>
            <.card_action>
              <button>Settings</button>
            </.card_action>
          </.card_header>
          <.card_content>
            <p>Main content here</p>
          </.card_content>
          <.card_footer align={:between}>
            <span>Left</span>
            <button>Right</button>
          </.card_footer>
        </.card>
        """)

      assert html =~ ~s(data-component="card")
      assert html =~ ~s(data-card-part="header")
      assert html =~ ~s(data-layout="row")
      assert html =~ ~s(data-card-part="title")
      assert html =~ "Dashboard"
      assert html =~ ~s(data-card-part="description")
      assert html =~ "Overview of your account"
      assert html =~ ~s(data-card-part="action")
      assert html =~ ~s(data-card-part="content")
      assert html =~ "Main content here"
      assert html =~ ~s(data-card-part="footer")
      assert html =~ ~s(data-align="between")
    end
  end
end
