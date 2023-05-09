--
-- Database: `prenotiamo`
--
DROP DATABASE IF EXISTS `prenotiamo`;
CREATE DATABASE IF NOT EXISTS `prenotiamo` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `prenotiamo`;

-- --------------------------------------------------------

--
-- Struttura della tabella `company`
--

DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
  `company_id` int(11) NOT NULL,
  `name` varchar(85) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `company`
--

INSERT INTO `company` (`company_id`, `name`) VALUES
(2, 'Adatum S.r.l.'),
(3, 'Ares S.p.A.'),
(1, 'F.T.P. S.r.l.'),
(4, 'Misc');

-- --------------------------------------------------------

--
-- Struttura della tabella `daily_order_list`
--

DROP TABLE IF EXISTS `daily_order_list`;
CREATE TABLE `daily_order_list` (
  `date` date NOT NULL,
  `user_id` int(11) NOT NULL,
  `food_name` varchar(45) NOT NULL,
  `note` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `daily_order_list`
--

INSERT INTO `daily_order_list` (`date`, `user_id`, `food_name`, `note`) VALUES
('2022-12-17', 5, 'Tagliatelle al ragù', 'nota esempio 45'),
('2022-12-18', 1, 'Tortellini in brodo', 'da delega'),
('2022-12-18', 3, 'Pizza margherita', 'nota esempio 45'),
('2022-12-18', 7, 'Pizza margherita', 'nota esempio 45'),
('2022-12-19', 1, 'Fantasia di polipo', ''),
('2022-12-19', 3, 'Pizza margherita', 'da delega'),
('2022-12-19', 7, 'Carpaccio di spada', 'da delega'),
('2022-12-20', 4, 'Carpaccio di spada', 'da delega'),
('2022-12-20', 7, 'Pizza margherita', 'nota esempio 615'),
('2022-12-21', 3, 'Fantasia di polipo', ''),
('2022-12-21', 4, 'Penne all\'arabbiata', ''),
('2022-12-21', 8, 'Fantasia di polipo', 'da delega'),
('2022-12-22', 3, 'Pizza margherita', 'Senza basilico'),
('2022-12-22', 4, 'Tortellini alla panna', ''),
('2022-12-22', 7, 'Tagliatelle al ragù', ''),
('2022-12-22', 10, 'Pizza Capricciosa', ''),
('2022-12-23', 8, 'Tavolozza delle zie 1', ''),
('2022-12-24', 11, 'Tavolozza delle zie 1', ''),
('2022-12-27', 10, 'Tortellini in brodo', ''),
('2022-12-27', 11, 'Tortellini in brodo', ''),
('2022-12-27', 14, 'Tagliatelle al ragù', ''),
('2023-01-02', 3, 'Tortellini in brodo', ''),
('2023-01-03', 8, 'Pizza margherita', ''),
('2023-01-05', 5, 'Tavolozza delle zie 1', ''),
('2023-01-05', 16, 'Tavolozza delle zie 1', '');

-- --------------------------------------------------------

--
-- Struttura della tabella `menu`
--

DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `food_name` varchar(45) NOT NULL,
  `food_id` int(11) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `course` enum('antipasti','primi','secondi','pizze') NOT NULL,
  `img_id` int(11) UNSIGNED DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `menu`
--

INSERT INTO `menu` (`food_name`, `food_id`, `price`, `course`, `img_id`) VALUES
('Tavolozza delle zie 1', 1, '9.00', 'antipasti', 1),
('Tavolozza delle zie 2', 2, '9.00', 'antipasti', 2),
('Tortellini in brodo', 3, '9.00', 'primi', 3),
('Tagliatelle al ragù', 4, '8.00', 'primi', 4),
('Fantasia di polipo', 5, '12.00', 'secondi', 5),
('Carpaccio di spada', 6, '12.00', 'secondi', 6),
('Pizza margherita', 7, '5.00', 'pizze', 7),
('Penne all\'arabbiata', 10, '8.00', 'primi', 9),
('Pizza Capricciosa', 14, '7.50', 'pizze', 10),
('Tortellini alla panna', 41, '9.50', 'primi', 11),
('Pizza Marinara', 44, '10.00', 'pizze', 8);

-- --------------------------------------------------------

--
-- Struttura della tabella `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `company` varchar(85) DEFAULT NULL,
  `role` enum('Admin','Ordinante','Ristorante','Generico') NOT NULL DEFAULT 'Generico'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `user`
--

INSERT INTO `user` (`id`, `name`, `password`, `email`, `company`, `role`) VALUES
(3, 'Gino Pino', '$2b$10$uboPafl.R/TqqIjwHkWMNectzMkq7tgdLIF/c5hwvoNsbIbftZKKe', 'ginopino@mail.com', 'Adatum S.r.l.', 'Generico'),
(4, 'Mario Rossi', '$2b$10$KGW19OXkFaq44qJAaT.fjeC/PTZ2vqPSMgrGOMa.Cvgk4FQN.EBRS', 'mario.rossi@mail.com', 'Adatum S.r.l.', 'Generico'),
(5, 'Luigi Verdi', '$2b$10$8/YiIFX/Xa/3IFNE.EgyPOzeJsjW9coFFpiVCR8PpM9xsRr6et2f.', 'luigiverdi@mail.com', 'Ares S.p.A.', 'Ordinante'),
(6, 'maxtest', '$2b$10$sf4ld4kaci9rlka9x8k2/.OHVpN7ww60xBWYH2HrhW7ps.S.4Q0h.', 'maxtest@email.com', 'Adatum S.r.l.', 'Generico'),
(7, 'Massimo Bianchi', '$2b$10$ijOd/ia65K8dkewyeS39AOBn6PQ2OlpA9y/9c4PoLep8lxr1MCjSy', 'massimobianchi@mail.com', 'Misc', 'Ristorante'),
(8, 'Gerardo Cipriano', '$2b$10$Cy1G84MQM/Nh8B35W19Ea.3TvaDOxYu468ZKEsM0u/ZA3aWVT7fYG', 'gerardocipriano@mail.com', 'F.T.P. S.r.l.', 'Admin'),
(10, 'Ristorante', '$2b$10$RJWsfH7BsOzLJOhEwhZi7OA2928MGpmAiSh/csfU7o3sllIcpbvmy', 'ristorante@mail.com', 'Misc', 'Ristorante'),
(11, 'Ordinante', '$2b$10$g2x0KYSSXZCbgItD66rFH.59hXAZdUMhlbJthR4m2MIGTh0X0gYiu', 'ordinante@mail.com', 'Misc', 'Ordinante'),
(13, 'Massimiliano', '$2b$10$ZcOka1YeqO0g7vEk39Jfmerpxb/c0.GPddpGzul9s06kraJm57DUK', 'max2@mail.com', 'Misc', 'Admin'),
(14, 'Admin', '$2b$10$A92oce1jZl9I/hPORYSn9.xrQi2vYqoYg8iwu.ivVTeoT9nz0tipu', 'admin@mail.com', 'Misc', 'Admin'),
(15, 'Andrea Gialli', '$2b$10$tbBRhJCJBwV/JKajA.AGvOsZGbYZQCrVu7xGv/Zaj.iAVKGpALmle', 'andreagialli@mail.com', 'Ares S.p.A.', 'Generico'),
(16, 'ciao', '$2b$10$vsyrZLc71s1IDkMwN7yMK.iyWPuX3LZizE3Uc7qCSgS.n93jGFuke', 'ciao@ciao', 'F.T.P. S.r.l.', 'Generico'),
(17, 'b', '$2b$10$xt5O7XeshWFdRJFJDTt76ezL/0O0aj1egg9A8wm0oPC5ifPp8jsiS', 'ciao@cia', 'Adatum S.r.l.', 'Generico'),
(18, 'Andrea Viola', '$2b$10$kGE7mdNnFIyQt43B6rTPz.tWUyKW9tFBl8g0/a61xycK2sEKV/6fW', 'andrea@mail.com', 'Ares S.p.A.', 'Generico');

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`company_id`),
  ADD UNIQUE KEY `name_UNIQUE` (`name`),
  ADD KEY `FOREIGN` (`name`);

--
-- Indici per le tabelle `daily_order_list`
--
ALTER TABLE `daily_order_list`
  ADD PRIMARY KEY (`date`,`user_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `daily_order_list_ibfk_2` (`food_name`);

--
-- Indici per le tabelle `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`food_id`,`food_name`),
  ADD UNIQUE KEY `img_id_UNIQUE` (`img_id`),
  ADD KEY `INDEX` (`food_name`);

--
-- Indici per le tabelle `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`name`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `company_idx` (`company`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `company`
--
ALTER TABLE `company`
  MODIFY `company_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT per la tabella `daily_order_list`
--
ALTER TABLE `daily_order_list`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT per la tabella `menu`
--
ALTER TABLE `menu`
  MODIFY `food_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;
--
-- AUTO_INCREMENT per la tabella `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;




