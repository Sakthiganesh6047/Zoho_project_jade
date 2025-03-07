CREATE TABLE `Branch` (
	`branch_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`branch_name` VARCHAR(100) NOT NULL UNIQUE,
	`branch_district` VARCHAR(255) NOT NULL,
	`address` TEXT,
	`ifsc_code` VARCHAR(15) NOT NULL UNIQUE,
	`created_by` BIGINT NOT NULL,
	`created_on` BIGINT NOT NULL,
	`modified_by` BIGINT,
	`modified_on` BIGINT,
	PRIMARY KEY(`branch_id`)
);


CREATE TABLE `User` (
	`user_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`full_name` VARCHAR(100) NOT NULL,
	`email` VARCHAR(100) NOT NULL UNIQUE,
	`password_hash` VARCHAR(255) NOT NULL,
	`phone` VARCHAR(20) NOT NULL UNIQUE,
	`dob` DATE NOT NULL,
	`age` TINYINT NOT NULL,
	`gender` ENUM('male', 'female', 'others') NOT NULL,
	`user_type` ENUM('customer', 'employee') NOT NULL,
	`status` ENUM('active', 'locked') NOT NULL,
	`created_by` BIGINT NOT NULL,
	`modified_by` BIGINT,
	`modified_on` BIGINT,
	PRIMARY KEY(`user_id`)
);


CREATE TABLE `Account` (
	`account_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`customer_id` BIGINT NOT NULL,
	`branch_id` BIGINT NOT NULL,
	`account_type` ENUM('savings', 'current') NOT NULL,
	`balance` DECIMAL(15,2) NOT NULL,
	`account_status` ENUM('active', 'inactive', 'blocked', 'closed') NOT NULL DEFAULT 'active',
	`created_by` BIGINT NOT NULL,
	`created_at` BIGINT NOT NULL,
	`modified_by` BIGINT,
	`modified_on` BIGINT,
	PRIMARY KEY(`account_id`)
);


CREATE TABLE `Transaction` (
	`transaction_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`account_id` BIGINT NOT NULL,
	`customer_id` BIGINT NOT NULL,
	`amount` DECIMAL(15,2) NOT NULL,
	`closing_balance` DECIMAL NOT NULL,
	`transaction_type` ENUM('withdrawl', 'deposit', 'credit', 'debit') NOT NULL,
	`transaction_date` BIGINT NOT NULL,
	`description` VARCHAR(200),
	`transfer_reference` BIGINT,
	`transaction_status` ENUM('success', 'failed') NOT NULL,
	`created_by` BIGINT NOT NULL,
	PRIMARY KEY(`transaction_id`)
);


CREATE TABLE `Loan` (
	`loan_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`account_id` BIGINT NOT NULL,
	`loan_type` ENUM('home', 'car', 'bike', 'personal') NOT NULL,
	`loan_amount` DECIMAL(15,2) NOT NULL,
	`balance_amount` DECIMAL NOT NULL,
	`loan_status` ENUM('denied', 'alive', 'closed') NOT NULL,
	`branch_id` BIGINT,
	`approved_by` BIGINT NOT NULL,
	`created_on` BIGINT NOT NULL,
	`modified_by` BIGINT,
	`modified_on` BIGINT,
	PRIMARY KEY(`loan_id`)
);


CREATE TABLE `Card` (
	`card_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`account_id` BIGINT NOT NULL,
	`pin_hash` VARCHAR(255) NOT NULL,
	`card_type` ENUM('debit', 'credit') NOT NULL,
	`valid_upto` DATE NOT NULL,
	`valid_from` DATE NOT NULL,
	`card_status` ENUM('active', 'inactive') NOT NULL,
	`issued_by` BIGINT NOT NULL,
	`issued_on` BIGINT NOT NULL,
	`modified_by` BIGINT,
	`modified_on` BIGINT,
	PRIMARY KEY(`card_id`)
);


CREATE TABLE `Activity` (
	`activity_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`employee_id` BIGINT NOT NULL,
	`done_on` BIGINT,
	`activity_info` VARCHAR(255) NOT NULL,
	PRIMARY KEY(`activity_id`)
);


CREATE TABLE `Interest` (
	`loan_name` ENUM('car', 'bike', 'home', 'personal') NOT NULL,
	`interest_rate` DECIMAL NOT NULL UNIQUE,
	`modified_by` BIGINT,
	`modified_on` BIGINT,
	PRIMARY KEY(`loan_name`)
);


CREATE TABLE `Nominee` (
	`nominee_id` BIGINT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL UNIQUE,
	`phonenumber` VARCHAR(20) NOT NULL,
	`account_id` BIGINT NOT NULL,
	`created_by` BIGINT NOT NULL,
	`modified_by` BIGINT,
	`modified_on` BIGINT,
	`nominee_customer_id` BIGINT,
	PRIMARY KEY(`nominee_id`)
);


CREATE TABLE `Customer` (
	`customer_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`aadhar_number` VARCHAR(20) NOT NULL UNIQUE,
	`pan_id` VARCHAR(10) NOT NULL UNIQUE,
	`address` TEXT NOT NULL,
	PRIMARY KEY(`customer_id`)
);


CREATE TABLE `Employee` (
	`employee_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`role` ENUM('manager', 'gm', 'staff') NOT NULL,
	`branch` BIGINT,
	PRIMARY KEY(`employee_id`)
);


CREATE TABLE `Beneficiary` (
	`beneficiar_id` BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	`beneficiar_name` VARCHAR(100) NOT NULL,
	`bank_name` VARCHAR(100) NOT NULL,
	`account_number` BIGINT NOT NULL,
	`ifsc_code` VARCHAR(15) NOT NULL,
	`account_id` BIGINT NOT NULL,
	`created_by` BIGINT NOT NULL,
	`modified_by` BIGINT,
	`modified_on` BIGINT,
	PRIMARY KEY(`beneficiar_id`)
);


ALTER TABLE `Transaction`
ADD FOREIGN KEY(`account_id`) REFERENCES `Account`(`account_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Loan`
ADD FOREIGN KEY(`branch_id`) REFERENCES `Branch`(`branch_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Loan`
ADD FOREIGN KEY(`account_id`) REFERENCES `Account`(`account_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Card`
ADD FOREIGN KEY(`account_id`) REFERENCES `Account`(`account_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `Loan`
ADD FOREIGN KEY(`loan_type`) REFERENCES `Interest`(`loan_name`)
ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE `Employee`
ADD FOREIGN KEY(`employee_id`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `Customer`
ADD FOREIGN KEY(`customer_id`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `Account`
ADD FOREIGN KEY(`customer_id`) REFERENCES `Customer`(`customer_id`)
ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE `Activity`
ADD FOREIGN KEY(`employee_id`) REFERENCES `Employee`(`employee_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Employee`
ADD FOREIGN KEY(`branch`) REFERENCES `Branch`(`branch_id`)
ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE `Nominee`
ADD FOREIGN KEY(`account_id`) REFERENCES `Account`(`account_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `Account`
ADD FOREIGN KEY(`branch_id`) REFERENCES `Branch`(`branch_id`)
ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE `Account`
ADD FOREIGN KEY(`modified_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Transaction`
ADD FOREIGN KEY(`created_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Beneficiary`
ADD FOREIGN KEY(`account_id`) REFERENCES `Account`(`account_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `User`
ADD FOREIGN KEY(`modified_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `User`
ADD FOREIGN KEY(`created_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Beneficiary`
ADD FOREIGN KEY(`created_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Beneficiary`
ADD FOREIGN KEY(`modified_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Transaction`
ADD FOREIGN KEY(`customer_id`) REFERENCES `Customer`(`customer_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Account`
ADD FOREIGN KEY(`created_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Branch`
ADD FOREIGN KEY(`created_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Branch`
ADD FOREIGN KEY(`modified_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Nominee`
ADD FOREIGN KEY(`created_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Nominee`
ADD FOREIGN KEY(`modified_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Card`
ADD FOREIGN KEY(`issued_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Card`
ADD FOREIGN KEY(`modified_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Interest`
ADD FOREIGN KEY(`modified_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Loan`
ADD FOREIGN KEY(`approved_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Loan`
ADD FOREIGN KEY(`modified_by`) REFERENCES `User`(`user_id`)
ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE `Nominee`
ADD FOREIGN KEY(`nominee_customer_id`) REFERENCES `Customer`(`customer_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE `Card`
ADD FOREIGN KEY(`account_id`) REFERENCES `Account`(`account_id`)
ON UPDATE CASCADE ON DELETE CASCADE;
