-- Copyright (C) 2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
--
-- This file is part of repology
--
-- repology is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- repology is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with repology.  If not, see <http://www.gnu.org/licenses/>.

WITH updated_cpes AS (
	SELECT
		jsonb_array_elements(matches)->>0 AS cpe_vendor,
		jsonb_array_elements(matches)->>1 AS cpe_product
	FROM cves INNER JOIN cve_updates USING (cve_id)
)
UPDATE project_hashes
SET hash = -1
WHERE effname IN (
	SELECT effname
	FROM project_cpe INNER JOIN updated_cpes USING (cpe_vendor, cpe_product)
);

DELETE FROM cve_updates;
