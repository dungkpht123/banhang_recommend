CREATE TABLE `product` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `sku` varchar(255),
  `description` text,
  `short_description` text,
  `thumbnail_url` varchar(255),
  `brand_id` bigint,
  `price` float,
  `is_active` bool,
  `is_published` bool,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `product_option` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `product_id` bigint,
  `name` varchar(255),
  `price` float,
  `is_active` bool,
  `is_published` bool,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `attribute` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(45)
);

CREATE TABLE `option_attribute_value` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `option_id` bigint,
  `attribute_id` bigint,
  `value` varchar(45)
);

CREATE TABLE `product_image` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `product_id` bigint,
  `url` varchar(255),
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `product_rating` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `product_id` bigint,
  `user_id` bigint,
  `comment` varchar(255),
  `star_number` int,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `category` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `is_active` bool,
  `is_published` bool,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `product_category` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `product_id` bigint,
  `category_id` bigint,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `brand` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `is_active` bool,
  `is_published` bool,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `user` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `avatar` varchar(255),
  `email` varchar(255),
  `gender` varchar(255),
  `birthday` date,
  `phone_number` varchar(45),
  `is_active` bool,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `user_account` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `user_id` bigint,
  `email` varchar(255),
  `phone_number` varchar(45),
  `password` varchar(255),
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `user_address` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `user_id` bigint,
  `ward_id` bigint,
  `phone_number` varchar(45),
  `name` varchar(255),
  `specific_address` varchar(255),
  `is_default` bool,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `user_favorite` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `user_id` bigint,
  `product_id` bigint,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `sale_order` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `user_id` bigint,
  `user_address_id` bigint,
  `subtotal_price` float,
  `total_price` float,
  `total_discounts` float,
  `delivery_fee` float,
  `payment_method_id` bigint,
  `status` varchar(45),
  `cancel_reason` varchar(45),
  `pay_at` timestamp,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `sale_order_item` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `product_id` bigint,
  `product_option_id` bigint,
  `order_id` bigint,
  `price` float,
  `quantity` int,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `sale_transaction` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `order_id` bigint,
  `user_id` bigint,
  `status` varchar(45),
  `amount` float,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `sale_cart` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `user_id` bigint,
  `subtotal_price` float,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `sale_cart_item` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `cart_id` bigint,
  `product_id` bigint,
  `product_option_id` bigint,
  `quantity` int,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `address_ward` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `province_id` bigint,
  `district_id` bigint,
  `code` varchar(20),
  `is_available` bool
);

CREATE TABLE `address_province` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `code` varchar(20),
  `is_available` bool
);

CREATE TABLE `address_district` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `province_id` bigint,
  `code` varchar(20),
  `is_available` bool
);

CREATE TABLE `payment_method` (
  `id` bigint PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255)
);

ALTER TABLE `product` ADD FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`);

ALTER TABLE `product_option` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `option_attribute_value` ADD FOREIGN KEY (`option_id`) REFERENCES `product_option` (`id`);

ALTER TABLE `option_attribute_value` ADD FOREIGN KEY (`attribute_id`) REFERENCES `attribute` (`id`);

ALTER TABLE `product_image` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `product_rating` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `product_rating` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `product_category` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `product_category` ADD FOREIGN KEY (`category_id`) REFERENCES `category` (`id`);

ALTER TABLE `user_account` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `user_address` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `user_address` ADD FOREIGN KEY (`ward_id`) REFERENCES `address_ward` (`id`);

ALTER TABLE `user_favorite` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `user_favorite` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `sale_order` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `sale_order` ADD FOREIGN KEY (`user_address_id`) REFERENCES `user_address` (`id`);

ALTER TABLE `sale_order` ADD FOREIGN KEY (`payment_method_id`) REFERENCES `payment_method` (`id`);

ALTER TABLE `sale_order_item` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `sale_order_item` ADD FOREIGN KEY (`product_option_id`) REFERENCES `product_option` (`id`);

ALTER TABLE `sale_order_item` ADD FOREIGN KEY (`order_id`) REFERENCES `sale_order` (`id`);

ALTER TABLE `sale_transaction` ADD FOREIGN KEY (`order_id`) REFERENCES `sale_order` (`id`);

ALTER TABLE `sale_transaction` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `sale_cart` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `sale_cart_item` ADD FOREIGN KEY (`cart_id`) REFERENCES `sale_cart` (`id`);

ALTER TABLE `sale_cart_item` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `sale_cart_item` ADD FOREIGN KEY (`product_option_id`) REFERENCES `product_option` (`id`);

ALTER TABLE `address_ward` ADD FOREIGN KEY (`province_id`) REFERENCES `address_province` (`id`);

ALTER TABLE `address_ward` ADD FOREIGN KEY (`district_id`) REFERENCES `address_district` (`id`);

ALTER TABLE `address_district` ADD FOREIGN KEY (`province_id`) REFERENCES `address_province` (`id`);
