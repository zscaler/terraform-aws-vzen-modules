################################################################################
# Configure target group
################################################################################
resource "aws_lb_target_group" "gwlb_target_group" {

  name                 = var.target_group_name
  port                 = 6081
  protocol             = "GENEVE"
  vpc_id               = var.vpc_id
  target_type          = "ip"

  health_check {
    port                = var.http_probe_port
    protocol            = "TCP"
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = 5
  }

}

################################################################################
# Register all VZEN Forwarding Service Interface IPs as targets to gwlb
################################################################################
resource "aws_lb_target_group_attachment" "gwlb_target_group_attachment" {
  count            = length(var.vzen_service_ips)
  target_group_arn = aws_lb_target_group.gwlb_target_group.arn
  target_id        = element(var.vzen_service_ips, count.index)
}


#################################################################################
## Configure the load balancer and listener
#################################################################################
resource "aws_lb" "gwlb" {
  load_balancer_type               = "gateway"
  name                             = var.gwlb_name

  subnets = var.vzen_subnet_ids

  ip_address_type = "ipv4"

  tags = merge(var.global_tags,
    { Name = var.gwlb_name }
  )

}

resource "aws_lb_listener" "gwlb_listener" {

  load_balancer_arn = aws_lb.gwlb.id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_target_group.id
  }

}
