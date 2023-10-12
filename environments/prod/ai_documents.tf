resource "google_document_ai_processor" "document_ai_processors" {
  project  = module.prod_project.project_id
  location = "us"

  for_each = {
    client-docs-ocr : "OCR_PROCESSOR"
    client-docs-parser : "FORM_PARSER_PROCESSOR"
  }
  display_name = each.key
  type         = each.value
}
