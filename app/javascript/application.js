// Entry point for the build script in your package.json
import "bootstrap/js/dist/alert";
import "bootstrap/js/dist/collapse";
import "bootstrap/js/dist/dropdown";
import Rails from "@rails/ujs"

Rails.start();

import "./delete_account";
import "./more_items";
import "./show_line_chart";
import "./show_modal";
import "./show_search_categories";
import "./show_search_comment";
import "./show_toast";
