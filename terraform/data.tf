data "archive_file" "app_dist_zip" {
  type        = "zip"
  source_dir  = "../${path.root}/${var.app_dist}"
  output_path = "../${path.root}/${var.app_dist}.zip"
}
