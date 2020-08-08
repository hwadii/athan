# Athan: prayer times

> Prayer times command line utility

# CLI

The CLI accepts the following arguments:

- `-cCITY` or `--city CITY`: the city for which to get prayer times
- `-dCOUNTRY` or `--country COUNTRY`: the country of the city from which to get
    prayer times

# Web API

The endpoint to use is this one: `http://api.aladhan.com/v1/calendarByCity`

## Example usage

This example queries the timings for Rabat, Morocco using
_UOIF's_ method.

```
http://api.aladhan.com/v1/calendarByCity?city=Rabat&country=Morocco&method=12
```

## Additional parameters

You can also give the following parameters:

-   `month (string)` - A Gregorian calendar month
-   `year (string)` - A Gregorian calendar year
-   `annual (boolean)` - If true, will ignore the month and return
    the entire year
-   `method (number)` - Use `12`

# TODO

- [ ] Accept different formatting options through the CLI
    - [ ] `-t` or `--three` to get next three days of prayer times
    - [ ] `-J` or `--json` to get output in raw json for usage in other scripts
    - [ ] `-f` or `--fetch` which accepts a date and gets the prayer times of an arbitrary date
- [ ] Better caching mechanism (dotfile?, encryption?)
