#!/usr/bin/env python3
import csv
import json
from pprint import pformat

FILE = "directions.csv"

direction_map = {}

with open(FILE) as file:
	reader = csv.DictReader(file)
	for row in reader:
	    route = row["route"]
	    direction_zero = row.get('0')
	    direction_one = row.get('1')

	    if not route in direction_map:
	        direction_map[route] = dict()

	    if direction_zero and direction_zero != "None":
	        direction_map[route][0] = direction_zero
	    if direction_one and direction_one != "None":
	        direction_map[route][1] = direction_one

print(pformat(direction_map))
