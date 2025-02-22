#!/usr/bin/env python3

"""
Processes data of the form
[
  {
    "route_id": "107",
    "trip_id": "944067",
    "direction_id": 1,
    "trip_headsign": "69th Street Transportation Center",
    . . .
    "direction_name": "Eastbound",
    "status": "ON-TIME"
  },
  ...
 ]

 in a JSON file and lists the correlations between direction id and direction name.
 First assembles a dict of the form

 [route: str][direction: int][translation: set[str]]

Then outputs this as a tab-delimited table to stdout.
"""
import json
from collections import defaultdict
from pprint import pformat

# organize into a map of the form [route: str][direction: int][translation: set[str]]

def inner_map():
    return defaultdict(list)

def outer_map():
    return defaultdict(inner_map)

mapped = outer_map()

FILE_NAME = "response.json"

with open(FILE_NAME) as f:
    data = f.read()
    data_list = json.loads(data)
    
for item in data_list:
    route, direction, direction_name = item.get("route_id"), item.get("direction_id"), item.get("direction_name")
    if direction_name and direction_name not in mapped[route][direction]:
        mapped[route][direction].append(direction_name)

plain_dict = json.loads(plain_json_mapped := json.dumps(mapped, indent=3))

for route in plain_dict:
    plain_dict_zeroset, plain_dict_oneset = plain_dict[route].get("0"), plain_dict[route].get("1")
    zero = plain_dict_zeroset[0] if plain_dict_zeroset and len(plain_dict_zeroset) <= 1 else None
    one = plain_dict_oneset[0] if plain_dict_oneset and len(plain_dict_oneset) <= 1 else None

    print(f"{route}\t{zero}\t{one}")
