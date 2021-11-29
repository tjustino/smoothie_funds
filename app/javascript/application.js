// Entry point for the build script in your package.json
import Alert    from "bootstrap/js/dist/alert";
import Collapse from "bootstrap/js/dist/collapse";
import Dropdown from "bootstrap/js/dist/dropdown";
import Rails    from "@rails/ujs"

Rails.start();

require("./delete_account");
require("./more_items");
require("./show_line_chart");
require("./show_modal");
require("./show_search_categories");
require("./show_search_comment");
require("./show_toast");
