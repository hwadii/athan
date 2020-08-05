# Athan: prayer times

> Prayer times command line utility

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

- `month (string)` - A Gregorian calendar month
- `year (string)` - A Gregorian calendar year
- `annual (boolean)` - If true, will ignore the month and return
    the entire year
- `method (number)` - Use `12`
