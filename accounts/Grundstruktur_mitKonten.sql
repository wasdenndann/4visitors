-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 20. Mrz 2022 um 07:07
-- Server-Version: 10.4.17-MariaDB
-- PHP-Version: 8.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `test`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `beschreibungkk`
--

CREATE TABLE `beschreibungkk` (
  `ID_beschreibungkk` int(8) NOT NULL,
  `beschreibung` varchar(100) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `betroffener`
--

CREATE TABLE `betroffener` (
  `ID_betroffener` int(8) NOT NULL,
  `betroffener` varchar(200) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `buchungstext`
--

CREATE TABLE `buchungstext` (
  `ID_buchungstext` int(8) NOT NULL,
  `text` varchar(100) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `clag`
--

CREATE TABLE `clag` (
  `ID_log` int(8) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `datei` varchar(50) COLLATE utf8_german2_ci NOT NULL,
  `start` int(8) NOT NULL,
  `ende` int(8) NOT NULL,
  `fk_ID_owner` int(8) NOT NULL,
  `saldo` decimal(10,2) DEFAULT NULL,
  `saldo_datum` date NOT NULL,
  `calc` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `currency`
--

CREATE TABLE `currency` (
  `ID_currency` int(8) NOT NULL,
  `kurz` varchar(4) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `depot`
--

CREATE TABLE `depot` (
  `ID_depot` int(8) NOT NULL,
  `fk_ID_owner` int(8) NOT NULL,
  `fk_ID_stocks` int(8) NOT NULL,
  `bestand` int(8) NOT NULL,
  `datum` date NOT NULL,
  `kurs_aktuell` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `giro`
--

CREATE TABLE `giro` (
  `ID_giro` int(8) NOT NULL,
  `buchungstag` date NOT NULL,
  `wertstellung` date NOT NULL,
  `betrag` decimal(10,2) NOT NULL,
  `stand` decimal(10,2) DEFAULT NULL,
  `fk_ID_buchungstext` int(8) NOT NULL,
  `fk_ID_betroffener` int(8) NOT NULL,
  `detail` varchar(200) COLLATE utf8_german2_ci DEFAULT NULL,
  `fk_ID_klasse_1` int(8) DEFAULT NULL,
  `fk_ID_klasse_2` int(8) DEFAULT NULL,
  `fk_ID_owner` int(8) NOT NULL,
  `fk_ID_zweck` int(8) NOT NULL,
  `fk_ID_iban` int(8) NOT NULL,
  `fk_ID_schuldner` int(8) DEFAULT NULL,
  `fk_ID_mandat` int(8) DEFAULT NULL,
  `fk_ID_kundenref` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `iban`
--

CREATE TABLE `iban` (
  `ID_iban` int(8) NOT NULL,
  `iban` varchar(34) COLLATE utf8_german2_ci NOT NULL,
  `blz` varchar(11) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `kk`
--

CREATE TABLE `kk` (
  `ID_kk` int(8) NOT NULL,
  `wertstellung` date NOT NULL,
  `belegdatum` date NOT NULL,
  `fk_ID_owner` int(8) NOT NULL,
  `fk_ID_beschreibungkk` int(8) NOT NULL,
  `betrag` decimal(10,2) NOT NULL,
  `stand` decimal(10,2) DEFAULT NULL,
  `ursprung_betrag` decimal(10,2) DEFAULT NULL,
  `fk_ID_currency` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `klasse`
--

CREATE TABLE `klasse` (
  `ID_klasse` int(8) NOT NULL,
  `klasse` varchar(50) COLLATE utf8_german2_ci NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `kundenreferenz`
--

CREATE TABLE `kundenreferenz` (
  `ID_kundenref` int(8) NOT NULL,
  `kundenreferenz` varchar(100) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mandatsreferenz`
--

CREATE TABLE `mandatsreferenz` (
  `ID_mandat` int(8) NOT NULL,
  `mandatsreferenz` varchar(100) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `owner`
--

CREATE TABLE `owner` (
  `ID_owner` int(8) NOT NULL,
  `bezeichnung` varchar(20) COLLATE utf8_german2_ci NOT NULL,
  `ktonummer` varchar(10) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

--
-- Daten für Tabelle `owner`
--

INSERT INTO `owner` (`ID_owner`, `bezeichnung`, `ktonummer`) VALUES
(1, 'Konto Peter', '6139'),
(2, 'Konto Gala', '4889'),
(3, 'Visa Gala', '0669'),
(4, 'Visa Brest', '0651'),
(5, 'Visa Peter', '0366'),
(6, 'Depot Peter', '3389');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `schuldner`
--

CREATE TABLE `schuldner` (
  `ID_schuldner` int(8) NOT NULL,
  `glaubiger_id` varchar(100) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stocks`
--

CREATE TABLE `stocks` (
  `ID_stocks` int(8) NOT NULL,
  `isin` varchar(20) NOT NULL,
  `name` varchar(250) NOT NULL,
  `einstandswert` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `zweck`
--

CREATE TABLE `zweck` (
  `ID_zweck` int(8) NOT NULL,
  `verwendung` varchar(1000) COLLATE utf8_german2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `beschreibungkk`
--
ALTER TABLE `beschreibungkk`
  ADD PRIMARY KEY (`ID_beschreibungkk`);

--
-- Indizes für die Tabelle `betroffener`
--
ALTER TABLE `betroffener`
  ADD PRIMARY KEY (`ID_betroffener`);

--
-- Indizes für die Tabelle `buchungstext`
--
ALTER TABLE `buchungstext`
  ADD PRIMARY KEY (`ID_buchungstext`);

--
-- Indizes für die Tabelle `clag`
--
ALTER TABLE `clag`
  ADD PRIMARY KEY (`ID_log`),
  ADD KEY `fk_clag_owner` (`fk_ID_owner`);

--
-- Indizes für die Tabelle `currency`
--
ALTER TABLE `currency`
  ADD PRIMARY KEY (`ID_currency`);

--
-- Indizes für die Tabelle `depot`
--
ALTER TABLE `depot`
  ADD PRIMARY KEY (`ID_depot`);

--
-- Indizes für die Tabelle `giro`
--
ALTER TABLE `giro`
  ADD PRIMARY KEY (`ID_giro`),
  ADD KEY `fk_giro_buchungstext` (`fk_ID_buchungstext`),
  ADD KEY `fk_giro_betroffener` (`fk_ID_betroffener`),
  ADD KEY `fk_giro_klasse_1` (`fk_ID_klasse_1`),
  ADD KEY `fk_giro_klasse_2` (`fk_ID_klasse_2`),
  ADD KEY `fk_giro_owner` (`fk_ID_owner`),
  ADD KEY `fk_giro_zweck` (`fk_ID_zweck`),
  ADD KEY `fk_giro_iban` (`fk_ID_iban`),
  ADD KEY `fk_giro_schuldner` (`fk_ID_schuldner`),
  ADD KEY `fk_giro_mandatsreferenz` (`fk_ID_mandat`),
  ADD KEY `fk_giro_kundenreferenz` (`fk_ID_kundenref`);

--
-- Indizes für die Tabelle `iban`
--
ALTER TABLE `iban`
  ADD PRIMARY KEY (`ID_iban`);

--
-- Indizes für die Tabelle `kk`
--
ALTER TABLE `kk`
  ADD PRIMARY KEY (`ID_kk`),
  ADD KEY `fk_ID_owner` (`fk_ID_owner`),
  ADD KEY `fk_kk_currency` (`fk_ID_currency`),
  ADD KEY `fk_kk_beschreibungkk` (`fk_ID_beschreibungkk`);

--
-- Indizes für die Tabelle `klasse`
--
ALTER TABLE `klasse`
  ADD PRIMARY KEY (`ID_klasse`);

--
-- Indizes für die Tabelle `kundenreferenz`
--
ALTER TABLE `kundenreferenz`
  ADD PRIMARY KEY (`ID_kundenref`);

--
-- Indizes für die Tabelle `mandatsreferenz`
--
ALTER TABLE `mandatsreferenz`
  ADD PRIMARY KEY (`ID_mandat`);

--
-- Indizes für die Tabelle `owner`
--
ALTER TABLE `owner`
  ADD PRIMARY KEY (`ID_owner`);

--
-- Indizes für die Tabelle `schuldner`
--
ALTER TABLE `schuldner`
  ADD PRIMARY KEY (`ID_schuldner`);

--
-- Indizes für die Tabelle `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`ID_stocks`);

--
-- Indizes für die Tabelle `zweck`
--
ALTER TABLE `zweck`
  ADD PRIMARY KEY (`ID_zweck`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `beschreibungkk`
--
ALTER TABLE `beschreibungkk`
  MODIFY `ID_beschreibungkk` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `betroffener`
--
ALTER TABLE `betroffener`
  MODIFY `ID_betroffener` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `buchungstext`
--
ALTER TABLE `buchungstext`
  MODIFY `ID_buchungstext` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `clag`
--
ALTER TABLE `clag`
  MODIFY `ID_log` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `currency`
--
ALTER TABLE `currency`
  MODIFY `ID_currency` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `depot`
--
ALTER TABLE `depot`
  MODIFY `ID_depot` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `giro`
--
ALTER TABLE `giro`
  MODIFY `ID_giro` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `iban`
--
ALTER TABLE `iban`
  MODIFY `ID_iban` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `kk`
--
ALTER TABLE `kk`
  MODIFY `ID_kk` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `klasse`
--
ALTER TABLE `klasse`
  MODIFY `ID_klasse` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `kundenreferenz`
--
ALTER TABLE `kundenreferenz`
  MODIFY `ID_kundenref` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `mandatsreferenz`
--
ALTER TABLE `mandatsreferenz`
  MODIFY `ID_mandat` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `owner`
--
ALTER TABLE `owner`
  MODIFY `ID_owner` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT für Tabelle `schuldner`
--
ALTER TABLE `schuldner`
  MODIFY `ID_schuldner` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `stocks`
--
ALTER TABLE `stocks`
  MODIFY `ID_stocks` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `zweck`
--
ALTER TABLE `zweck`
  MODIFY `ID_zweck` int(8) NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `clag`
--
ALTER TABLE `clag`
  ADD CONSTRAINT `fk_clag_owner` FOREIGN KEY (`fk_ID_owner`) REFERENCES `owner` (`ID_owner`);

--
-- Constraints der Tabelle `giro`
--
ALTER TABLE `giro`
  ADD CONSTRAINT `fk_giro_betroffener` FOREIGN KEY (`fk_ID_betroffener`) REFERENCES `betroffener` (`ID_betroffener`),
  ADD CONSTRAINT `fk_giro_buchungstext` FOREIGN KEY (`fk_ID_buchungstext`) REFERENCES `buchungstext` (`ID_buchungstext`),
  ADD CONSTRAINT `fk_giro_iban` FOREIGN KEY (`fk_ID_iban`) REFERENCES `iban` (`ID_iban`),
  ADD CONSTRAINT `fk_giro_klasse_1` FOREIGN KEY (`fk_ID_klasse_1`) REFERENCES `klasse` (`ID_klasse`),
  ADD CONSTRAINT `fk_giro_klasse_2` FOREIGN KEY (`fk_ID_klasse_2`) REFERENCES `klasse` (`ID_klasse`),
  ADD CONSTRAINT `fk_giro_kundenreferenz` FOREIGN KEY (`fk_ID_kundenref`) REFERENCES `kundenreferenz` (`ID_kundenref`),
  ADD CONSTRAINT `fk_giro_mandatsreferenz` FOREIGN KEY (`fk_ID_mandat`) REFERENCES `mandatsreferenz` (`ID_mandat`),
  ADD CONSTRAINT `fk_giro_owner` FOREIGN KEY (`fk_ID_owner`) REFERENCES `owner` (`ID_owner`),
  ADD CONSTRAINT `fk_giro_schuldner` FOREIGN KEY (`fk_ID_schuldner`) REFERENCES `schuldner` (`ID_schuldner`),
  ADD CONSTRAINT `fk_giro_zweck` FOREIGN KEY (`fk_ID_zweck`) REFERENCES `zweck` (`ID_zweck`);

--
-- Constraints der Tabelle `kk`
--
ALTER TABLE `kk`
  ADD CONSTRAINT `fk_kk_beschreibungkk` FOREIGN KEY (`fk_ID_beschreibungkk`) REFERENCES `beschreibungkk` (`ID_beschreibungkk`),
  ADD CONSTRAINT `fk_kk_owner` FOREIGN KEY (`fk_ID_owner`) REFERENCES `owner` (`ID_owner`),
  ADD CONSTRAINT `fk_kk_currency` FOREIGN KEY (`fk_ID_currency`) REFERENCES `currency`(`ID_currency`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
