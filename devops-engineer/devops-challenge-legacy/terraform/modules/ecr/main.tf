locals {
  principals_readonly_access_non_empty = length(var.principals_readonly_access) > 0 ? true : false
  principals_full_access_non_empty     = length(var.principals_full_access) > 0 ? true : false
  ecr_need_policy                      = length(var.principals_full_access) + length(var.principals_readonly_access) > 0 ? true : false
}

resource "aws_ecr_repository" "name" {
  for_each             = toset(var.image_names)
  name                 = each.value
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_images_on_push
  }

  tags = var.tags
}

locals {
  untagged_image_rule = [{
    rulePriority = 1
    description  = "Remove untagged images"
    selection = {
      tagStatus   = "untagged"
      countType   = "imageCountMoreThan"
      countNumber = 1
    }
    action = {
      type = "expire"
    }
  }]

  remove_old_image_rule = [{
    rulePriority = 2
    description  = "Rotate images when reach ${var.max_image_count} images stored",
    selection = {
      tagStatus   = "any"
      countType   = "imageCountMoreThan"
      countNumber = var.max_image_count
    }
    action = {
      type = "expire"
    }
  }]
}

resource "aws_ecr_lifecycle_policy" "name" {
  for_each   = toset(var.image_names)
  repository = aws_ecr_repository.name[each.value].name

  policy = jsonencode({
    rules = concat(local.untagged_image_rule, local.remove_old_image_rule)
  })
}

