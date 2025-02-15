-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 09, 2022 at 01:35 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nfr_v1`
--

-- --------------------------------------------------------

--
-- Table structure for table `nfr_revolut`
--

CREATE TABLE `nfr_revolut` (
  `user_id` int(11) NOT NULL,
  `pin` int(11) NOT NULL,
  `verified` int(11) NOT NULL DEFAULT 0,
  `lastSentAmount` int(11) NOT NULL,
  `lastNameSent` text NOT NULL DEFAULT 'INVALID',
  `lastIdSent` int(11) NOT NULL,
  `lastRecievedAmount` int(11) NOT NULL,
  `lastNameRecieved` text NOT NULL DEFAULT 'INVALID',
  `lastIdRecieved` int(11) NOT NULL,
  `color` text NOT NULL DEFAULT 'rgb(255, 255, 255)',
  `textcolor` text NOT NULL DEFAULT 'rgb(109, 109, 109)',
  `rewardCoins` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nfr_revolut`
--

INSERT INTO `nfr_revolut` (`user_id`, `pin`, `verified`, `lastSentAmount`, `lastNameSent`, `lastIdSent`, `lastRecievedAmount`, `lastNameRecieved`, `lastIdRecieved`, `color`, `textcolor`, `rewardCoins`) VALUES
(1, 2268, 1, 0, 'INVALID', 0, 0, 'INVALID', 0, 'rgb(255, 255, 255)', 'rgb(109, 109, 109)', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `nfr_revolut`
--
ALTER TABLE `nfr_revolut`
  ADD UNIQUE KEY `user_id` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
