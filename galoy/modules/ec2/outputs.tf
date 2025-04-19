output "free_tier_instance_ip" {
    value = aws_instance.free_tier_instance.public_ip
}