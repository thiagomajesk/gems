defmodule GEMSWeb.ErrorHTMLTest do
  use GEMSWeb.ConnCase, async: true

  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(GEMSWeb.ErrorHTML, "404", "html", []) ==
             "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(GEMSWeb.ErrorHTML, "500", "html", []) ==
             "Internal Server Error"
  end
end
