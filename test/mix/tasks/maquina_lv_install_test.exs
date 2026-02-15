defmodule Mix.Tasks.MaquinaLv.InstallTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @css_import ~s|@import "../../deps/maquina_lv/assets/css/maquina_lv.css";|
  @css_source ~s|@source "../../deps/maquina_lv/lib";|
  @js_import ~s|import { MaquinaHooks } from "maquina_lv"|

  setup do
    tmp_dir =
      Path.join(
        System.tmp_dir!(),
        "maquina_lv_install_test_#{System.unique_integer([:positive])}"
      )

    File.mkdir_p!(Path.join(tmp_dir, "assets/css"))
    File.mkdir_p!(Path.join(tmp_dir, "assets/js"))

    # Create default files so most tests have both present
    File.write!(Path.join(tmp_dir, "assets/css/app.css"), "@import \"tailwindcss\";\n")
    File.write!(Path.join(tmp_dir, "assets/js/app.js"), "import {Socket} from \"phoenix\"\n")

    original_dir = File.cwd!()
    File.cd!(tmp_dir)

    on_exit(fn ->
      File.cd!(original_dir)
      File.rm_rf!(tmp_dir)
    end)

    %{tmp_dir: tmp_dir}
  end

  describe "CSS import injection" do
    test "injects CSS import after @import tailwindcss" do
      capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme", "--skip-js"]) end)

      content = File.read!("assets/css/app.css")
      assert content =~ @css_import
      assert content =~ @css_source
      # Should appear after tailwindcss import
      assert Regex.match?(~r/tailwindcss.*#{Regex.escape(@css_import)}/s, content)
    end

    test "injects CSS import with single-quoted tailwindcss" do
      File.write!("assets/css/app.css", "@import 'tailwindcss';\n")

      capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme", "--skip-js"]) end)

      content = File.read!("assets/css/app.css")
      assert content =~ @css_import
    end

    test "skips if CSS import already present" do
      File.write!("assets/css/app.css", """
      @import "tailwindcss";

      #{@css_import}
      #{@css_source}
      """)

      output =
        capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme", "--skip-js"]) end)

      assert output =~ "already present"

      # Content should remain unchanged
      content = File.read!("assets/css/app.css")

      import_count =
        content
        |> String.split(@css_import)
        |> length()
        |> Kernel.-(1)

      assert import_count == 1
    end

    test "handles missing CSS file gracefully" do
      File.rm!("assets/css/app.css")

      output =
        capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme", "--skip-js"]) end)

      assert output =~ "not found"
    end
  end

  describe "theme variables" do
    test "appends theme variables to CSS file" do
      capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-js"]) end)

      content = File.read!("assets/css/app.css")
      assert content =~ "--color-primary:"
      assert content =~ "--background:"
      assert content =~ "@theme"
      assert content =~ ".dark"
    end

    test "skips theme variables with --skip-theme" do
      capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme", "--skip-js"]) end)

      content = File.read!("assets/css/app.css")
      refute content =~ "--color-primary:"
    end

    test "skips theme variables if already present" do
      File.write!("assets/css/app.css", """
      @import "tailwindcss";

      @theme {
        --color-primary: var(--primary);
      }
      """)

      output = capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-js"]) end)
      assert output =~ "already present"
    end
  end

  describe "JS hooks import" do
    test "injects JS hooks import at the top" do
      capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme"]) end)

      content = File.read!("assets/js/app.js")
      assert content =~ @js_import
      assert String.starts_with?(content, @js_import)
    end

    test "skips JS import with --skip-js" do
      capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme", "--skip-js"]) end)

      content = File.read!("assets/js/app.js")
      refute content =~ @js_import
    end

    test "skips JS import if already present" do
      File.write!("assets/js/app.js", """
      #{@js_import}
      import {Socket} from "phoenix"
      """)

      output = capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme"]) end)
      assert output =~ "already present"
    end

    test "handles missing JS file gracefully" do
      File.rm!("assets/js/app.js")

      output = capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run(["--skip-theme"]) end)
      assert output =~ "not found"
    end
  end

  describe "idempotency" do
    test "running twice does not duplicate imports" do
      capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run([]) end)
      capture_io(fn -> Mix.Tasks.MaquinaLv.Install.run([]) end)

      css_content = File.read!("assets/css/app.css")
      js_content = File.read!("assets/js/app.js")

      # CSS import should appear exactly once
      css_import_count =
        css_content
        |> String.split(@css_import)
        |> length()
        |> Kernel.-(1)

      assert css_import_count == 1

      # JS import should appear exactly once
      js_import_count =
        js_content
        |> String.split(@js_import)
        |> length()
        |> Kernel.-(1)

      assert js_import_count == 1

      # Theme variables should appear exactly once
      theme_count =
        css_content
        |> String.split("--color-primary:")
        |> length()
        |> Kernel.-(1)

      assert theme_count == 1
    end
  end
end
