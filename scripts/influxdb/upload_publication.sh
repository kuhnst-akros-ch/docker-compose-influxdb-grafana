#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

FILE="$1"

JSON="$(python $SCRIPT_DIR/xml2json.py "$FILE")"
JSON="$(echo "$JSON" | python $SCRIPT_DIR/clean-json.py)"

PUBLICATION_DATE="$(echo "$JSON" | python $SCRIPT_DIR/get-field-from-json.py "publicationDate")"

LINE="$(echo "$JSON" | python $SCRIPT_DIR/json2line.py)"
LINE="publication,$LINE value=\"$PUBLICATION_DATE\" $(date -d "$PUBLICATION_DATE" +%s)"

echo "LINE="
echo "$LINE"

LINE='publication,id="000fb284-e89b-4765-a889-c2389f1b79eb",rubric="BP-BS",subRubric="BP-BS10",language="de",displayName="Bau-\ und\ Gastgewerbeinspektorat\ des\ Kantons\ Basel-Stadt\ -\ Baubewilligungen\ und\ -kontrolle",street="M▒nsterplatz",streetNumber="11",swissZipCode="4051",town="Basel",containsPostOfficeBox="false",publicationNumber="BP-BS10-0000004537",publicationState="PUBLISHED",publicationDate="2024-06-26",expirationDate="2024-09-26",primaryTenantCode="kabbs",cantons="BS",de="Abbruch\ (und\ Neubau):\ Gellertstrasse\ 142\,\ 144\,\ 146\,\ 150\,\ 156\,\ 182\,\ 184\ /\ Scherkesselweg\ 5\,\ 7\,\ 9\,\ 15\,\ Basel",en="EN_Abbruch\ (und\ Neubau):\ Gellertstrasse\ 142\,\ 144\,\ 146\,\ 150\,\ 156\,\ 182\,\ 184\ /\ Scherkesselweg\ 5\,\ 7\,\ 9\,\ 15\,\ Basel",it="IT_Abbruch\ (und\ Neubau):\ Gellertstrasse\ 142\,\ 144\,\ 146\,\ 150\,\ 156\,\ 182\,\ 184\ /\ Scherkesselweg\ 5\,\ 7\,\ 9\,\ 15\,\ Basel",fr="FR_Abbruch\ (und\ Neubau):\ Gellertstrasse\ 142\,\ 144\,\ 146\,\ 150\,\ 156\,\ 182\,\ 184\ /\ Scherkesselweg\ 5\,\ 7\,\ 9\,\ 15\,\ Basel",selectType="demolition",noUID="false",name="Stiftung\ Diakonat\ Bethesda",uid="CHE-115.311.751",uidOrganisationId="115311751",uidOrganisationIdCategorie="CHE",legalForm="0110",houseNumber="144",projectDescription="R▒ckbau\ 2\ Geb▒ude\,\ Neubau\ 3\ Wohnh▒user\ mit\ unterirdischer\ Autoeinstellhalle\,\ Baumf▒llungen\ und\ Ersatzpflanzungen",address=[{'street': 'Gellertstrasse', 'houseNumber': '142, 144, 146, 150, 156, 182, 184', 'town': 'Basel'}, {'street': 'Scherkesselweg', 'houseNumber': '5, 7, 9, 15', 'town': 'Basel'}],section="5",plot="478\,\ 1508\,\ 1560\,\ 3075",locationCirculationOffice="Die\ betreffenden\ Pl▒ne\ k▒nnen\ jeweils\ werktags\ von\ 08.00\ -\ 12.15\ und\ 13.15\ -\ 17.00\ Uhr\ beim\ Empfang\ des\ Bau-\ und\ Verkehrsdepartements\,\ M▒nsterplatz\ 11\,\ eingesehen\ werden.\ https://www.bgi.bs.ch",entryDeadline="2024-07-26" value="2024-06-26" 1719352800'

echo "$LINE" > $SCRIPT_DIR/line.out

echo "$LINE" | $SCRIPT_DIR/insert-line.sh

# printf "Data from $FILE uploaded as:\n$LINE\n"