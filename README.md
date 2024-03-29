# Athan: prayer times

> Prayer times command line utility

# CLI

## Usage

The CLI accepts the following arguments:

- a string representing the city and country: e.g. `Rabat/Morocco`.
- `-sSEP, --sep SEP`: the separator to be used between city and country. Default:
    `'/'`.
- `-m, --more`: prints other notable timings besides the five daily prayers.
- `-t, --three`: prints the next three days worth of prayer timings, including
    the current day.
- `-J, --json`: prints output as a json, to be consumed by another program.
- `-fDATE, --fetch DATE`: prints the prayer timings for the given day.
- `-n, --next`: prints the timing of the next prayer of the day.

## Example

Print the prayer timings for the current date.
```bash
$ ./bin/athan 'Rabat/Morocco'
```

Print the prayer timings for the next three days including the current one.
```bash
$ ./bin/athan -t 'Rabat/Morocco'
```

Print other notable timings besides the five daily prayers.
```bash
$ ./bin/athan -tm 'Rabat/Morocco'
```

Print the output as json.
```bash
$ ./bin/athan -J 'Rabat/Morocco'
```

It is also possible to combine options. For example, print next three days as
json.
```bash
$ ./bin/athan -tJ 'Rabat/Morocco'
```

Or print the timings for a given date as json.
```bash
$ ./bin/athan -Jf'2020-08-03' 'Rabat/Morocco'
```

# Web API

The endpoint to use is this one: `http://api.aladhan.com/v1/calendarByCity`

## Example usage

This example queries the timings for Rabat, Morocco using
_UOIF's_ method.

```bash
$ curl -s http://api.aladhan.com/v1/calendarByCity\?city\=Rabat\&country\=Morocco\&method\=12 | jq
```

## Additional parameters

You can also give the following parameters:

-   `month (string)` - A Gregorian calendar month
-   `year (string)` - A Gregorian calendar year
-   `annual (boolean)` - If true, will ignore the month and return
    the entire year
-   `method (number)` - Use `12`

# Setup

To use this program you need `ruby` and `bundle`, then run the following at the
root of the project:
```bash
$ bundle install
```
# TODO

- [ ] Disable colors if not a tty
- [ ] Use `xdg` to get correct cache location
- [ ] Invalidate cache if new month
