defmodule MaquinaLv.TableTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Table

  # ── table/1 ──────────────────────────────────────────────────────────

  describe "table/1" do
    test "renders a table with data-component='table' inside a container div" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table>content</.table>
        """)

      assert html =~ ~s(data-component="table")
      assert html =~ "<table"
      assert html =~ ~s(data-table-part="container")
      assert html =~ "<div"
    end

    test "wraps table in container div by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table>content</.table>
        """)

      assert html =~ ~s(data-table-part="container")
    end

    test "wraps table in container div when container is explicitly true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table container={true}>content</.table>
        """)

      assert html =~ ~s(data-table-part="container")
    end

    test "does not wrap table in container div when container is false" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table container={false}>content</.table>
        """)

      refute html =~ ~s(data-table-part="container")
      refute html =~ "<div"
      assert html =~ "<table"
      assert html =~ ~s(data-component="table")
    end

    test "emits data-variant on container when variant is set" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table variant="bordered">content</.table>
        """)

      assert html =~ ~s(data-variant="bordered")
    end

    test "does not emit data-variant on container when variant is nil" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table>content</.table>
        """)

      # The container div should not have data-variant
      # (the table element also should not have data-variant when table_variant is nil)
      refute html =~ "data-variant"
    end

    test "emits data-variant on table element when table_variant is set" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table table_variant="striped">content</.table>
        """)

      assert html =~ ~s(data-variant="striped")
    end

    test "does not emit data-variant on table when table_variant is nil" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table>content</.table>
        """)

      refute html =~ "data-variant"
    end

    test "passes class attribute to the table element" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table class="my-table">content</.table>
        """)

      assert html =~ ~s(class="my-table")
    end

    test "passes global attributes to the table element" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table id="tbl">content</.table>
        """)

      assert html =~ ~s(id="tbl")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table>
          <tr><td>cell</td></tr>
        </.table>
        """)

      assert html =~ "<td>cell</td>"
    end
  end

  # ── table_header/1 ───────────────────────────────────────────────────

  describe "table_header/1" do
    test "renders a thead with data-table-part='header'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_header>content</.table_header>
        """)

      assert html =~ ~s(data-table-part="header")
      assert html =~ "<thead"
    end

    test "does not emit data-sticky when sticky is false (default)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_header>content</.table_header>
        """)

      refute html =~ "data-sticky"
    end

    test "does not emit data-sticky when sticky is explicitly false" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_header sticky={false}>content</.table_header>
        """)

      refute html =~ "data-sticky"
    end

    test "emits data-sticky='true' when sticky is true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_header sticky={true}>content</.table_header>
        """)

      assert html =~ ~s(data-sticky="true")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_header class="extra">content</.table_header>
        """)

      assert html =~ ~s(class="extra")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_header id="hdr">content</.table_header>
        """)

      assert html =~ ~s(id="hdr")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_header>
          <tr><th>Header</th></tr>
        </.table_header>
        """)

      assert html =~ "<th>Header</th>"
    end
  end

  # ── table_body/1 ─────────────────────────────────────────────────────

  describe "table_body/1" do
    test "renders a tbody with data-table-part='body'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_body>content</.table_body>
        """)

      assert html =~ ~s(data-table-part="body")
      assert html =~ "<tbody"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_body class="striped">content</.table_body>
        """)

      assert html =~ ~s(class="striped")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_body id="body">content</.table_body>
        """)

      assert html =~ ~s(id="body")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_body>
          <tr><td>Row</td></tr>
        </.table_body>
        """)

      assert html =~ "<td>Row</td>"
    end
  end

  # ── table_row/1 ──────────────────────────────────────────────────────

  describe "table_row/1" do
    test "renders a tr with data-table-part='row'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_row>content</.table_row>
        """)

      assert html =~ ~s(data-table-part="row")
      assert html =~ "<tr"
    end

    test "does not emit data-state when selected is false (default)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_row>content</.table_row>
        """)

      refute html =~ "data-state"
    end

    test "does not emit data-state when selected is explicitly false" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_row selected={false}>content</.table_row>
        """)

      refute html =~ "data-state"
    end

    test "emits data-state='selected' when selected is true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_row selected={true}>content</.table_row>
        """)

      assert html =~ ~s(data-state="selected")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_row class="highlight">content</.table_row>
        """)

      assert html =~ ~s(class="highlight")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_row id="row-1">content</.table_row>
        """)

      assert html =~ ~s(id="row-1")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_row>
          <td>Cell data</td>
        </.table_row>
        """)

      assert html =~ "<td>Cell data</td>"
    end
  end

  # ── table_head/1 ─────────────────────────────────────────────────────

  describe "table_head/1" do
    test "renders a th with data-table-part='head'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_head>Name</.table_head>
        """)

      assert html =~ ~s(data-table-part="head")
      assert html =~ "<th"
    end

    test "has scope='col' by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_head>Name</.table_head>
        """)

      assert html =~ ~s(scope="col")
    end

    test "allows custom scope attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_head scope="row">Name</.table_head>
        """)

      assert html =~ ~s(scope="row")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_head class="text-right">Amount</.table_head>
        """)

      assert html =~ ~s(class="text-right")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_head id="th-name">Name</.table_head>
        """)

      assert html =~ ~s(id="th-name")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_head>
          <span>Column Header</span>
        </.table_head>
        """)

      assert html =~ "<span>Column Header</span>"
    end
  end

  # ── table_cell/1 ─────────────────────────────────────────────────────

  describe "table_cell/1" do
    test "renders a td with data-table-part='cell'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_cell>data</.table_cell>
        """)

      assert html =~ ~s(data-table-part="cell")
      assert html =~ "<td"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_cell class="font-medium">data</.table_cell>
        """)

      assert html =~ ~s(class="font-medium")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_cell id="cell-1">data</.table_cell>
        """)

      assert html =~ ~s(id="cell-1")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_cell>
          <span>$250.00</span>
        </.table_cell>
        """)

      assert html =~ "<span>$250.00</span>"
    end
  end

  # ── table_footer/1 ───────────────────────────────────────────────────

  describe "table_footer/1" do
    test "renders a tfoot with data-table-part='footer'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_footer>content</.table_footer>
        """)

      assert html =~ ~s(data-table-part="footer")
      assert html =~ "<tfoot"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_footer class="bold">content</.table_footer>
        """)

      assert html =~ ~s(class="bold")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_footer id="ftr">content</.table_footer>
        """)

      assert html =~ ~s(id="ftr")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_footer>
          <tr><td>Total</td></tr>
        </.table_footer>
        """)

      assert html =~ "<td>Total</td>"
    end
  end

  # ── table_caption/1 ──────────────────────────────────────────────────

  describe "table_caption/1" do
    test "renders a caption with data-table-part='caption'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_caption>A list of invoices.</.table_caption>
        """)

      assert html =~ ~s(data-table-part="caption")
      assert html =~ "<caption"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_caption class="sr-only">Hidden caption</.table_caption>
        """)

      assert html =~ ~s(class="sr-only")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_caption id="cap">Caption</.table_caption>
        """)

      assert html =~ ~s(id="cap")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table_caption>
          <span>A list of recent invoices.</span>
        </.table_caption>
        """)

      assert html =~ "<span>A list of recent invoices.</span>"
    end
  end

  # ── Full composition ────────────────────────────────────────────────

  describe "full table composition" do
    test "all sub-components compose together correctly" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table variant="bordered" table_variant="striped">
          <.table_caption>A list of recent invoices.</.table_caption>
          <.table_header sticky={true}>
            <.table_row>
              <.table_head>Invoice</.table_head>
              <.table_head>Status</.table_head>
              <.table_head class="text-right">Amount</.table_head>
            </.table_row>
          </.table_header>
          <.table_body>
            <.table_row>
              <.table_cell class="font-medium">INV001</.table_cell>
              <.table_cell>Paid</.table_cell>
              <.table_cell class="text-right">$250.00</.table_cell>
            </.table_row>
            <.table_row selected={true}>
              <.table_cell class="font-medium">INV002</.table_cell>
              <.table_cell>Pending</.table_cell>
              <.table_cell class="text-right">$150.00</.table_cell>
            </.table_row>
          </.table_body>
          <.table_footer>
            <.table_row>
              <.table_cell>Total</.table_cell>
              <.table_cell></.table_cell>
              <.table_cell class="text-right">$400.00</.table_cell>
            </.table_row>
          </.table_footer>
        </.table>
        """)

      # Container
      assert html =~ ~s(data-table-part="container")
      assert html =~ ~s(data-variant="bordered")

      # Table
      assert html =~ ~s(data-component="table")
      assert html =~ ~s(data-variant="striped")

      # Caption
      assert html =~ ~s(data-table-part="caption")
      assert html =~ "A list of recent invoices."

      # Header
      assert html =~ ~s(data-table-part="header")
      assert html =~ ~s(data-sticky="true")

      # Head cells
      assert html =~ ~s(data-table-part="head")
      assert html =~ "Invoice"
      assert html =~ "Status"
      assert html =~ "Amount"

      # Body
      assert html =~ ~s(data-table-part="body")

      # Rows
      assert html =~ ~s(data-table-part="row")
      assert html =~ ~s(data-state="selected")

      # Cells
      assert html =~ ~s(data-table-part="cell")
      assert html =~ "INV001"
      assert html =~ "Paid"
      assert html =~ "$250.00"
      assert html =~ "INV002"
      assert html =~ "Pending"
      assert html =~ "$150.00"

      # Footer
      assert html =~ ~s(data-table-part="footer")
      assert html =~ "Total"
      assert html =~ "$400.00"
    end

    test "table without container composes correctly" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.table container={false}>
          <.table_header>
            <.table_row>
              <.table_head>Name</.table_head>
            </.table_row>
          </.table_header>
          <.table_body>
            <.table_row>
              <.table_cell>Alice</.table_cell>
            </.table_row>
          </.table_body>
        </.table>
        """)

      refute html =~ ~s(data-table-part="container")
      assert html =~ ~s(data-component="table")
      assert html =~ ~s(data-table-part="header")
      assert html =~ ~s(data-table-part="body")
      assert html =~ ~s(data-table-part="row")
      assert html =~ ~s(data-table-part="head")
      assert html =~ ~s(data-table-part="cell")
      assert html =~ "Name"
      assert html =~ "Alice"
    end
  end
end
